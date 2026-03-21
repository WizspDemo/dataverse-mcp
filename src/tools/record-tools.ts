import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { DataverseClient } from "../dataverse-client.js";

export function copyRecordTool(server: McpServer, client: DataverseClient) {
  server.registerTool(
    "copy_dataverse_record",
    {
      title: "Copy Dataverse Record",
      description: "Creates a copy of an existing Dataverse record. Uses the InitializeFrom API to create a new record pre-populated with values from the source record based on entity attribute mappings. Optionally overrides specific field values on the copy. Supports copying to the same or a mapped target entity type.",
      inputSchema: {
        sourceEntityLogicalName: z.string().describe("Logical name of the source entity (e.g., 'account', 'contact', 'opportunity')"),
        sourceRecordId: z.string().describe("GUID of the source record to copy"),
        targetEntityLogicalName: z.string().optional().describe("Logical name of the target entity to copy into. Defaults to the same entity as the source if not specified."),
        fieldOverrides: z.record(z.any()).optional().describe("Optional map of field logical names to values that will override the copied values on the new record (e.g., { 'name': 'Copy of Original' })"),
        targetEntitySetName: z.string().optional().describe("OData entity set name for the target entity (e.g., 'accounts', 'contacts'). If not provided, it will be inferred by appending 's' to the logical name.")
      }
    },
    async (params) => {
      try {
        const targetEntityLogicalName = params.targetEntityLogicalName || params.sourceEntityLogicalName;
        const targetEntitySetName = params.targetEntitySetName || `${targetEntityLogicalName}s`;

        // Use InitializeFrom to get a pre-populated copy of the record
        const entitySetName = `${params.sourceEntityLogicalName}s`;
        const initializeFromUrl = `InitializeFrom(EntityMoniker=@a,TargetEntityName=@b,TargetFieldType=@c)`;
        const queryParams = {
          '@a': `{'@odata.id':'${entitySetName}(${params.sourceRecordId})'}`,
          '@b': `'${targetEntityLogicalName}'`,
          '@c': `Microsoft.Dynamics.CRM.TargetFieldType'ValidForCreate'`
        };

        const initializedRecord = await client.get<Record<string, any>>(
          initializeFromUrl,
          queryParams
        );

        // Remove OData metadata fields that cannot be sent in a POST request
        const newRecord: Record<string, any> = {};
        for (const [key, value] of Object.entries(initializedRecord)) {
          if (!key.startsWith('@') && key !== 'odata.context') {
            newRecord[key] = value;
          }
        }

        // Apply any field overrides specified by the caller
        if (params.fieldOverrides) {
          for (const [field, value] of Object.entries(params.fieldOverrides)) {
            newRecord[field] = value;
          }
        }

        // Create the new record and capture the new record ID
        const newRecordId = await client.create(targetEntitySetName, newRecord);

        return {
          content: [
            {
              type: "text",
              text: `Successfully copied record.\n\nSource: ${params.sourceEntityLogicalName}(${params.sourceRecordId})\nTarget entity: ${targetEntityLogicalName}\nNew record ID: ${newRecordId}\n\nCopied fields:\n${JSON.stringify(newRecord, null, 2)}`
            }
          ]
        };
      } catch (error) {
        return {
          content: [
            {
              type: "text",
              text: `Error copying record: ${error instanceof Error ? error.message : 'Unknown error'}`
            }
          ],
          isError: true
        };
      }
    }
  );
}

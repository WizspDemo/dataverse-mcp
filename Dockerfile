FROM node:20-slim

# Εγκατάσταση Python
RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Αύξηση μνήμης για το build
ENV NODE_OPTIONS="--max-old-space-size=4096"

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Εγκατάσταση του mcp-proxy
RUN pip3 install --break-system-packages mcp-proxy

ENV PORT=8000
EXPOSE 8000

# Δημιουργία ενός wrapper script που κάνει export τις μεταβλητές 
# και μετά ξεκινάει τον proxy με shell execution
RUN echo '#!/bin/sh\n\
export DATAVERSE_URL=$DATAVERSE_URL\n\
export DATAVERSE_CLIENT_ID=$DATAVERSE_CLIENT_ID\n\
export DATAVERSE_CLIENT_SECRET=$DATAVERSE_CLIENT_SECRET\n\
export DATAVERSE_TENANT_ID=$DATAVERSE_TENANT_ID\n\
echo "Starting proxy with explicit env forwarding..."\n\
exec mcp-proxy --port 8000 node build/index.js' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

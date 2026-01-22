FROM node:20-slim

WORKDIR /app

# 1. Εγκατάσταση του tiny-mcp-proxy
RUN npm install -g tiny-mcp-proxy

# 2. Προετοιμασία του Dataverse MCP
COPY package*.json tsconfig.json ./
RUN npm install
COPY . .
RUN npm run build

# 3. Ρυθμίσεις
ENV PORT=8000
EXPOSE 8000

# 4. Εκκίνηση
# Ο tiny-mcp-proxy μετατρέπει το stdio του server σου σε SSE
CMD ["tiny-mcp-proxy", "node", "build/index.js"]

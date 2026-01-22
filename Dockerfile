FROM node:20-slim

WORKDIR /app

# 1. Εγκατάσταση του σωστού proxy που μετατρέπει το stdio σε SSE
RUN npm install -g @michaelfatigati/mcp-proxy

# 2. Προετοιμασία του Dataverse MCP
COPY package*.json tsconfig.json ./
RUN npm install
COPY . .
RUN npm run build

# 3. Ρυθμίσεις
ENV PORT=8000
EXPOSE 8000

# 4. Εκκίνηση του proxy που "αγκαλιάζει" τον server σου
# Ο proxy θα ακούει στην 8000 και θα στέλνει τα πάντα στο node build/index.js
CMD ["mcp-proxy", "node", "build/index.js"]

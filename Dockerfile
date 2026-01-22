FROM node:20-slim

WORKDIR /app

# 1. Εγκατάσταση του SSE Proxy παγκόσμια
RUN npm install -g @modelcontextprotocol/inspector

# 2. Αντιγραφή και εγκατάσταση του Dataverse MCP
COPY package*.json tsconfig.json ./
RUN npm install
COPY . .
RUN npm run build

# 3. Ρυθμίσεις δικτύου
ENV PORT=8000
EXPOSE 8000

# 4. Η "μαγική" εντολή: 
# Ο proxy ακούει στην 8000 και τρέχει από πίσω τον server σου
CMD ["npx", "-y", "@modelcontextprotocol/inspector", "node", "build/index.js"]

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
# Ορίζουμε την πόρτα 8000 και απενεργοποιούμε το token για να μπορεί να συνδεθεί το Claude
CMD ["npx", "-y", "@modelcontextprotocol/inspector", "--port", "8000", "--host", "0.0.0.0", "--dangerously-omit-auth", "--", "node", "build/index.js"]

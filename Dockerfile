FROM node:20-slim

WORKDIR /app

# Αντιγραφή αρχείων ρυθμίσεων
COPY package*.json tsconfig.json ./

# Εγκατάσταση εξαρτήσεων
RUN npm install

# Αντιγραφή κώδικα και Build
COPY . .
RUN npm run build

# Ορισμός μεταβλητών μέσα στο Docker για σιγουριά
ENV MCP_TRANSPORT=sse
ENV PORT=8000

EXPOSE 8000

# Απευθείας εκτέλεση του build αρχείου με τις παραμέτρους SSE
# Χρησιμοποιούμε το node απευθείας αντί για npm start
CMD ["node", "build/index.js", "--transport", "sse", "--port", "8000"]

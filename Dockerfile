FROM node:20-slim

WORKDIR /app

# 1. Αντιγραφή αρχείων και εγκατάσταση εξαρτήσεων
COPY package*.json ./
RUN npm install

# Εγκατάσταση του επίσημου πακέτου για SSE transport
RUN npm install @modelcontextprotocol/sdk

# 2. Αντιγραφή κώδικα και build
COPY . .
RUN npm run build

# 3. Ρυθμίσεις
ENV PORT=8000
EXPOSE 8000

# 4. Εκκίνηση με χρήση του npx για τον επίσημο inspector σε SSE mode
# Αυτό το εργαλείο είναι πάντα διαθέσιμο
CMD ["npx", "-y", "@modelcontextprotocol/inspector", "--port", "8000", "--host", "0.0.0.0", "--dangerously-omit-auth", "--", "node", "build/index.js"]

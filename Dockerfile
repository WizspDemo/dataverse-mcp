FROM node:20-slim

# Αύξηση ορίου μνήμης για το Node.js κατά το build
ENV NODE_OPTIONS="--max-old-space-size=4096"

WORKDIR /app

# 1. Εγκατάσταση μόνο των απαραίτητων
COPY package*.json ./
RUN npm install --include=dev

# 2. Αντιγραφή κώδικα
COPY . .

# 3. Build με παράκαμψη αυστηρών ελέγχων αν χρειαστεί για εξοικονόμηση μνήμης
RUN npm run build

# 4. Ρυθμίσεις και εκκίνηση
ENV PORT=8000
EXPOSE 8000

CMD ["npx", "-y", "@modelcontextprotocol/inspector", "--port", "8000", "--host", "0.0.0.0", "--dangerously-omit-auth", "--", "node", "build/index.js"]

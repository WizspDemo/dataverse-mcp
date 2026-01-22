FROM node:20-slim

# Εγκατάσταση Python για τον proxy
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

# ΕΔΩ ΕΙΝΑΙ Η ΛΥΣΗ: Περνάμε τις μεταβλητές ρητά μέσα στην εντολή εκκίνησης
CMD ["sh", "-c", "mcp-proxy --port 8000 node build/index.js"]

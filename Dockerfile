FROM node:20-slim

# Εγκατάσταση απαραίτητων εργαλείων
RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Αύξηση μνήμης για το build
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Εγκατάσταση εξαρτήσεων
COPY package*.json ./
RUN npm install

# Αντιγραφή και Build
COPY . .
RUN npm run build

# Εγκατάσταση του mcp-proxy (Python version)
RUN pip3 install --break-system-packages mcp-proxy

ENV PORT=8000
EXPOSE 8000

# Δημιουργία script που ελέγχει τις μεταβλητές πριν ξεκινήσει
RUN echo '#!/bin/sh\n\
echo "--- DEBUG INFO ---"\n\
echo "DATAVERSE_URL is: $DATAVERSE_URL"\n\
echo "DATAVERSE_TENANT_ID is: $DATAVERSE_TENANT_ID"\n\
echo "------------------"\n\
mcp-proxy --port 8000 node build/index.js' > /app/start.sh && chmod +x /app/start.sh

CMD ["/app/start.sh"]

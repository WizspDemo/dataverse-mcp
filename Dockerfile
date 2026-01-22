FROM node:20-slim

RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Εγκατάσταση εξαρτήσεων
COPY package*.json ./
RUN npm install

# Αντιγραφή και Build
COPY . .
RUN npm run build

# Εγκατάσταση του mcp-proxy
RUN pip3 install --break-system-packages mcp-proxy

# ΔΗΜΙΟΥΡΓΙΑ WRAPPER ΓΙΑ ΤΟ NODE
# Αυτό το αρχείο θα εκτελείται από τον proxy και θα "κουβαλάει" τις μεταβλητές
RUN echo '#!/bin/sh\n\
node /app/build/index.js' > /app/run-node.sh && chmod +x /app/run-node.sh

ENV PORT=8000
EXPOSE 8000

# Εκτέλεση του proxy καλώντας το wrapper script αντί για απευθείας το node
CMD ["sh", "-c", "mcp-proxy --port 8000 /app/run-node.sh"]

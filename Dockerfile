FROM node:20-slim

RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

RUN pip3 install --break-system-packages mcp-proxy

ENV PORT=8000
EXPOSE 8000

# ΑΥΤΟ ΕΙΝΑΙ ΤΟ ΚΛΕΙΔΙ: 
# Δημιουργούμε το script χρησιμοποιώντας τις τιμές των μεταβλητών ΤΗΝ ΩΡΑ ΤΟΥ DEPLOY
# Έτσι ο Node θα τις βρει σίγουρα, γιατί θα είναι γραμμένες μέσα στο αρχείο.
RUN echo '#!/bin/sh\n\
export DATAVERSE_URL="'$DATAVERSE_URL'"\n\
export DATAVERSE_CLIENT_ID="'$DATAVERSE_CLIENT_ID'"\n\
export DATAVERSE_CLIENT_SECRET="'$DATAVERSE_CLIENT_SECRET'"\n\
export DATAVERSE_TENANT_ID="'$DATAVERSE_TENANT_ID'"\n\
node /app/build/index.js' > /app/run-node.sh && chmod +x /app/run-node.sh

CMD ["sh", "-c", "mcp-proxy --port 8000 /app/run-node.sh"]

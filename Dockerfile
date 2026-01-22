FROM node:20-slim

WORKDIR /app

# Αντιγραφή των αρχείων ρυθμίσεων
COPY package*.json tsconfig.json ./

# Εγκατάσταση των εξαρτήσεων
RUN npm install

# Αντιγραφή του υπόλοιπου κώδικα
COPY . .

# Build του TypeScript (αν χρειάζεται)
RUN npm run build || echo "No build script found, skipping..."

ENV PORT=8000
EXPOSE 8000

# Εκκίνηση της εφαρμογής
# Αν το "main" στο package.json δείχνει στο σωστό αρχείο:
CMD ["npm", "start"]

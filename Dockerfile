FROM node:20-slim
WORKDIR /app
# Αντιγραφή μόνο των αρχείων ρυθμίσεων για ταχύτητα
COPY package*.json tsconfig.json ./
RUN npm install
# Αντιγραφή όλου του κώδικα
COPY . .
# Δημιουργία των αρχείων JavaScript από το TypeScript
RUN npm run build
ENV PORT=8000
EXPOSE 8000
# Εκκίνηση
#CMD ["npm", "start", "--", "--transport", "sse", "--port", "8000"]
CMD ["node", "build/index.js", "--transport", "sse", "--port", "8000"]

FROM python:3.11-slim-bookworm

# Εγκατάσταση του uv (πολύ γρήγορος package manager)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Ορίζουμε τον κατάλογο εργασίας μέσα στο container
WORKDIR /app

# Αντιγράφουμε τα αρχεία από το Base Directory που ορίσαμε (dataverse-mcp)
COPY . .

# Εγκατάσταση των εξαρτήσεων απευθείας στο σύστημα του container
RUN uv pip install --system .

# Ρυθμίσεις δικτύου - Ο server "ακούει" στην 8000
ENV PORT=8000
EXPOSE 8000

# Εκκίνηση της εφαρμογής ως module με SSE transport
ENTRYPOINT ["python", "-m", "mcp_server_dataverse", "--transport", "sse", "--port", "8000"]

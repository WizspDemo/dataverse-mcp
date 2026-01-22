FROM python:3.11-slim-bookworm

# Εγκατάσταση του uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Ορίζουμε τον φάκελο εργασίας
WORKDIR /app

# Αντιγράφουμε τα αρχεία (το Coolify θα αντιγράψει μόνο το περιεχόμενο του Base Directory εδώ)
COPY . .

# Εγκατάσταση των εξαρτήσεων
RUN uv pip install --system .

# Ρυθμίσεις δικτύου
ENV PORT=8000
EXPOSE 8000

# Εκκίνηση της εφαρμογής
ENTRYPOINT ["python", "-m", "mcp_server_dataverse", "--transport", "sse", "--port", "8000"]

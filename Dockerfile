FROM python:3.11-slim-bookworm

# Εγκατάσταση του uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Αντιγραφή όλων των αρχείων
COPY . .

# Εγκατάσταση των εξαρτήσεων απευθείας
RUN uv pip install --system .

# Ρυθμίσεις δικτύου
ENV PORT=8000
EXPOSE 8000

# Εκκίνηση
ENTRYPOINT ["python", "-m", "mcp_server_dataverse", "--transport", "sse", "--port", "8000"]

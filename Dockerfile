FROM python:3.11-slim-bookworm

# Εγκατάσταση του uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Αντιγραφή όλων των αρχείων
COPY . .

# Εγκατάσταση εξαρτήσεων
# Χρησιμοποιούμε το --system για να είναι πιο απλό μέσα στο Docker
RUN uv pip install --system .

# Ρυθμίσεις δικτύου
ENV PORT=8000
EXPOSE 8000

# Εκκίνηση - Χρησιμοποιούμε απευθείας το module
ENTRYPOINT ["python", "-m", "mcp_server_dataverse", "--transport", "sse", "--port", "8000"]

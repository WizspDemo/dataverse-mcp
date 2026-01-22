FROM python:3.11-slim-bookworm

# Εγκατάσταση του uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Αντιγραφή ΟΛΩΝ των αρχείων από το repository
COPY . .

# Μετακίνηση στον υποφάκελο όπου βρίσκεται το pyproject.toml
# Αν ο φάκελος λέγεται dataverse-mcp, μπαίνουμε εκεί
WORKDIR /app/dataverse-mcp

# Εγκατάσταση των εξαρτήσεων από το τρέχον σημείο (.)
RUN uv pip install --system .

# Επιστροφή στο /app για την εκτέλεση
WORKDIR /app

ENV PORT=8000
EXPOSE 8000

# Εκκίνηση - Προσαρμοσμένο path για το module
ENTRYPOINT ["python", "-m", "mcp_server_dataverse", "--transport", "sse", "--port", "8000"]

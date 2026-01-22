FROM python:3.11-slim-bookworm

# Εγκατάσταση του uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Ορισμός φακέλου
WORKDIR /app

# Αντιγραφή ΟΛΩΝ των αρχείων από το GitHub στο container
COPY . .

# Εγκατάσταση εξαρτήσεων (το uv θα βρει μόνο του το pyproject.toml)
RUN uv sync

# Ρυθμίσεις δικτύου
ENV PORT=8000
EXPOSE 8000

# Εκκίνηση
ENTRYPOINT ["uv", "run", "mcp-server-dataverse", "--transport", "sse", "--port", "8000"]

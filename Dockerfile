FROM python:3.11-slim-bookworm

# Εγκατάσταση του uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Αντιγραφή των πάντων από το repository
COPY . .

# ΕΝΤΟΛΗ DEBUG: Δείξε μας τι υπάρχει μέσα για να ξέρουμε σίγουρα
RUN echo "Checking directory structure..." && ls -R

# ΕΞΥΠΝΗ ΕΓΚΑΤΑΣΤΑΣΗ: 
# Ψάχνει το pyproject.toml στη ρίζα ή στον υποφάκελο και εγκαθιστά από εκεί
RUN if [ -f "pyproject.toml" ]; then \
        uv pip install --system .; \
    elif [ -d "dataverse-mcp" ] && [ -f "dataverse-mcp/pyproject.toml" ]; then \
        cd dataverse-mcp && uv pip install --system .; \
    else \
        echo "Error: pyproject.toml not found!" && exit 1; \
    fi

ENV PORT=8000
EXPOSE 8000

# Εκκίνηση
ENTRYPOINT ["python", "-m", "mcp_server_dataverse", "--transport", "sse", "--port", "8000"]

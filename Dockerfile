# 1. Χρήση ελαφριάς εικόνας Python
FROM python:3.11-slim-bookworm

# 2. Εγκατάσταση του uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# 3. Περιβάλλον εργασίας
WORKDIR /app

# 4. Μεταβλητές περιβάλλοντος
ENV PYTHONUNBUFFERED=1
ENV PORT=8000

# 5. Αντιγραφή ΜΟΝΟ του pyproject.toml (αφαιρέσαμε το uv.lock)
COPY pyproject.toml ./

# 6. Εγκατάσταση εξαρτήσεων (αφαιρέσαμε το --frozen γιατί δεν έχουμε lock file)
RUN uv sync --no-install-project

# 7. Αντιγραφή του υπόλοιπου κώδικα
COPY . .

# 8. Τελική εγκατάσταση
RUN uv sync

# 9. Εκκίνηση
EXPOSE 8000
ENTRYPOINT ["uv", "run", "mcp-server-dataverse", "--transport", "sse", "--port", "8000"]

# 1. Χρήση ελαφριάς εικόνας Python
FROM python:3.11-slim-bookworm

# 2. Εγκατάσταση του uv για ταχύτητα και διαχείριση lockfiles
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# 3. Περιβάλλον εργασίας
WORKDIR /app

# 4. Μεταβλητές περιβάλλοντος για την Python (no buffering για logs)
ENV PYTHONUNBUFFERED=1
ENV PORT=8000

# 5. Αντιγραφή αρχείων εξαρτήσεων
COPY pyproject.toml uv.lock ./

# 6. Εγκατάσταση εξαρτήσεων
RUN uv sync --frozen --no-install-project

# 7. Αντιγραφή του υπόλοιπου κώδικα
COPY . .

# 8. Τελική εγκατάσταση του project
RUN uv sync --frozen

# 9. Εκκίνηση σε SSE mode στην πόρτα 8000
# Σημείωση: Το πακέτο ονομάζεται συνήθως από το pyproject.toml
EXPOSE 8000
ENTRYPOINT ["uv", "run", "mcp-server-dataverse", "--transport", "sse", "--port", "8000"]

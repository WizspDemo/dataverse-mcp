# ... (τα προηγούμενα παραμένουν ίδια μέχρι το pip3 install) ...

RUN pip3 install --break-system-packages mcp-proxy

ENV PORT=8000
EXPOSE 8000

# Δημιουργούμε ένα μικρό script εκκίνησης για να είμαστε 100% σίγουροι
RUN echo '#!/bin/sh\n\
echo "Checking Environment Variables inside container..."\n\
echo "URL is: $DATAVERSE_URL"\n\
mcp-proxy --port 8000 node build/index.js' > /app/start.sh && chmod +x /app/start.sh

CMD ["/app/start.sh"]

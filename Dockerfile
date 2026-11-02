FROM python:3.11-slim

WORKDIR /app

# Copia a pasta de build da web e o script do servidor
COPY build/web /app/build/web
COPY server.py /app/server.py

ENV PORT=10000
EXPOSE 10000

CMD ["python", "server.py"]

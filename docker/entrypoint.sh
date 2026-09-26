#!/bin/sh
set -e

echo "Running database migrations..."
/app/.venv/bin/python scripts/provision_db.py

# Reconfigure pgvector column dims to match EMBEDDING_VECTOR_DIMENSIONS
# (default migrations create vector(1536); ALTER to target dim on first boot)
echo "Configuring pgvector dimensions..."
/app/.venv/bin/python scripts/configure_embeddings.py --yes || echo "WARN: configure_embeddings.py failed (continuing)"

echo "Starting API server..."
exec /app/.venv/bin/fastapi run --host 0.0.0.0 src/main.py

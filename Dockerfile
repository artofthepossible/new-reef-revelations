# syntax=docker/dockerfile:1

# -----------------------------
# Development stage
# -----------------------------
FROM demonstrationorg/dhi-python:3.13.3-alpine3.21-dev AS development

# Set DHI specific environment variables
ENV DHI_APP_ENV=development \
    DHI_LOG_LEVEL=DEBUG \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Create DHI recommended application user
ARG UID=10001
RUN addgroup -S appgroup && \
    adduser -S -D -H \
    -h /nonexistent \
    -s /sbin/nologin \
    -G appgroup \
    -u ${UID} \
    appuser

# Install development dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    linux-headers \
    postgresql-dev \
    wget

# Install Python dependencies
COPY --chown=appuser:appgroup requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install --upgrade pip && \
    python -m pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p /app/static /app/templates /app/data && \
    chown -R appuser:appgroup /app

# Copy application code
COPY --chown=appuser:appgroup . .

# Set development permissions
RUN chmod -R 755 /app

USER appuser

# -----------------------------
# Production stage
# -----------------------------
FROM demonstrationorg/dhi-python:3.13.3-alpine3.21 AS production

ENV DHI_APP_ENV=production \
    DHI_LOG_LEVEL=INFO \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Create production user
ARG UID=10001
RUN addgroup -S appgroup && \
    adduser -S -D -H \
    -h /nonexistent \
    -s /sbin/nologin \
    -G appgroup \
    -u ${UID} \
    appuser

# Install minimal production dependencies
RUN apk add --no-cache wget

# Copy only necessary files from development stage
COPY --from=development --chown=appuser:appgroup /app/requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install --upgrade pip && \
    python -m pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p /app/static /app/templates /app/data && \
    chown -R appuser:appgroup /app

# Copy application code from development stage
COPY --from=development --chown=appuser:appgroup /app/static /app/static/
COPY --from=development --chown=appuser:appgroup /app/templates /app/templates/
COPY --from=development --chown=appuser:appgroup /app/*.py /app/

# Set production permissions
RUN chmod -R 755 /app/static /app/templates && \
    chmod 644 /app/*.py

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8000/health || exit 1

CMD ["python", "app.py"]

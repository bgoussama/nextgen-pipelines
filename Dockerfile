FROM python:3.9-slim as builder

# Set working directory to /app
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Run command
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

# Create non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup -d /app -s /sbin/nologin -c 'app user' appuser

# Change ownership of /app to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Create final image
FROM python:3.9-slim

# Set working directory to /app
WORKDIR /app

# Copy application code from builder
COPY --from=builder /app .

# Expose port
EXPOSE 8000

# Run command
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
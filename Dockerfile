FROM python:3.10-slim

# Set working directory to /app
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port 80
EXPOSE 80

# Run command to start the development server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
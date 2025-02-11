# Use the base image (e.g., Python for FastAPI)
FROM python:3.10

# Install dependencies
RUN apt-get update && apt-get install -y nginx

# Copy the Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Install Python dependencies
WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . /app

# Expose port 80
EXPOSE 80

# Start Nginx and the application
CMD service nginx start && uvicorn main:app --host 0.0.0.0 --port 8000

# Use Python as the base image
FROM python:3.10

# Install system dependencies
RUN apt update && apt install -y nginx

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy FastAPI app files
COPY . .

# Copy Nginx configuration
COPY default.conf /etc/nginx/nginx.conf

# Expose port 80 for Nginx
EXPOSE 80

# Start both FastAPI and Nginx
CMD uvicorn main:app --host 0.0.0.0 --port 8000 & nginx -g "daemon off;"

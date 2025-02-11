# Use an official Python image
FROM python:3.10

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Set working directory
WORKDIR /app

# Copy FastAPI app
COPY . /app

# Copy Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose ports
EXPOSE 80

# Start both Nginx and FastAPI
CMD service nginx start && uvicorn main:app --host 0.0.0.0 --port 8000

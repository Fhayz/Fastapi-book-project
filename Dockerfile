# Use an official Python image
FROM python:3.10

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Set working directory
WORKDIR /app

# Copy your FastAPI app
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports
EXPOSE 80

# Start both Nginx and FastAPI
CMD service nginx start && uvicorn main:app --host 0.0.0.0 --port 8000

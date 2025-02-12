# Dockerfile
FROM python:3.10

# Install Nginx
RUN apt-get update && apt-get install -y nginx

WORKDIR /app
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create nginx configuration
RUN echo 'server {\n\
    listen $PORT;\n\
    server_name _;\n\
    \n\
    location / {\n\
        proxy_pass http://localhost:8000;\n\
        proxy_set_header Host $host;\n\
        proxy_set_header X-Real-IP $remote_addr;\n\
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n\
        proxy_set_header X-Forwarded-Proto $scheme;\n\
    }\n\
}\n'\
> /etc/nginx/conf.d/default.conf.template

# Create start script with proper error handling
RUN echo '#!/bin/bash\n\
export PORT=${PORT:-8000}\n\
echo "Port: $PORT"\n\
envsubst "\$PORT" < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf\n\
echo "Starting Nginx..."\n\
service nginx start\n\
echo "Starting FastAPI application..."\n\
exec uvicorn main:app --host 0.0.0.0 --port 8000\n'\
> /app/start.sh

RUN apt-get update && apt-get install -y gettext

RUN chmod +x /app/start.sh

# Expose the port
EXPOSE 8000

CMD ["/app/start.sh"]
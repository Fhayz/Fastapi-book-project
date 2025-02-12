FROM python:3.10

# Install Nginx and gettext-base (for envsubst)
RUN apt-get update && \
    apt-get install -y nginx gettext-base && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Configure Nginx
RUN echo 'events {\n\
    worker_connections 1024;\n\
}\n\
http {\n\
    include /etc/nginx/mime.types;\n\
    default_type application/octet-stream;\n\
    sendfile on;\n\
    keepalive_timeout 65;\n\
    \n\
    server {\n\
        listen $PORT default_server;\n\
        server_name _;\n\
        \n\
        location / {\n\
            proxy_pass http://127.0.0.1:8000;\n\
            proxy_set_header Host $host;\n\
            proxy_set_header X-Real-IP $remote_addr;\n\
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n\
            proxy_set_header X-Forwarded-Proto $scheme;\n\
        }\n\
    }\n\
}\n' > /etc/nginx/nginx.conf.template

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create start script with error handling
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
export PORT=${PORT:-8000}\n\
echo "Configuring Nginx for port $PORT..."\n\
envsubst "\$PORT" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf\n\
\n\
echo "Testing Nginx configuration..."\n\
nginx -t\n\
\n\
echo "Starting Nginx..."\n\
nginx\n\
\n\
echo "Starting FastAPI application..."\n\
exec uvicorn main:app --host 127.0.0.1 --port 8000\n' > /app/start.sh

RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
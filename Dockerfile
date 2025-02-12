FROM python:3.10

# Install Nginx
RUN apt-get update && apt-get install -y nginx

WORKDIR /app
COPY . /app

# Configure Nginx
RUN echo 'events { worker_connections 1024; }\n\
http {\n\
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

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create start script
RUN echo '#!/bin/bash\n\
export PORT=${PORT:-8000}\n\
envsubst "\$PORT" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf\n\
nginx -g "daemon off;" &\n\
uvicorn main:app --host 127.0.0.1 --port 8000\n' > /app/start.sh

RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
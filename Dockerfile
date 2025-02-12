FROM python:3.10

# Install Nginx
RUN apt-get update && apt-get install -y nginx

WORKDIR /app
COPY . /app

# Copy Nginx configuration
COPY default.conf /etc/nginx/templates/default.conf.template

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create start script
RUN echo '#!/bin/bash\n\
export PORT=${PORT:-80}\n\
envsubst \$PORT < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf\n\
nginx\n\
uvicorn main:app --host 127.0.0.1 --port 8000\n'\
> /app/start.sh

RUN chmod +x /app/start.sh

# Expose the port
EXPOSE ${PORT}

CMD ["/app/start.sh"]
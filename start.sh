#!/bin/bash

# Start FastAPI with Uvicorn
uvicorn main:app --host 0.0.0.0 --port 8000 &

# Start NGINX
nginx -g "daemon off;"

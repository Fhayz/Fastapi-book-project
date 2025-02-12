#!/bin/bash

echo "Starting FastAPI application..."
uvicorn main:app --host 0.0.0.0 --port 8000 &

echo "Starting Nginx..."
nginx -g "daemon off;"

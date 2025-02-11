# official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /code

#  To Copy requirements file and install dependencies
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# To Copy the FastAPI application code
COPY . /code

# To  Expose the port the app runs on
EXPOSE 8000

# To Run the FastAPI application with Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

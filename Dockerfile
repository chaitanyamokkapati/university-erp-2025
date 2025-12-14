
# Use a Python 3.11 base image
FROM python:3.11-slim-buster

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE university_erp.settings

# Set the working directory
WORKDIR /app

# Install system dependencies (if any, though not explicitly required by Django)
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     default-libmysqlclient-dev \
#     build-essential \
#     && rm -rf /var/lib/apt/lists/*

# Copy requirements file and install Python dependencies
COPY backend/requirements.txt /app/backend/requirements.txt
RUN pip install --no-cache-dir -r backend/requirements.txt

# Copy the entire project
COPY . /app/

# Change to the backend directory for Django commands
WORKDIR /app/backend

# Collect static files
# Ensure the `frontend/assets` path is correct relative to /app
RUN python manage.py collectstatic --noinput

# Apply database migrations
RUN python manage.py migrate

# Expose the port Gunicorn will listen on
EXPOSE 8000

# Command to run the Gunicorn server
CMD ["gunicorn", "university_erp.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "4"]

# syntax=docker/dockerfile:1


# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

#worse image
ARG PYTHON_VERSION=3.11.6

#better image
#ARG PYTHON_VERSION=3.12.5
#ARG PYTHON_VERSION=3.11.9
#FROM python:${PYTHON_VERSION}-slim
#alpine
#ARG PYTHON_VERSION=3.12.7-alpine 
#ARG PYTHON_VERSION=alpine 
FROM python:${PYTHON_VERSION}
#better image
#FROM python:alpine as base
#FROM python:alpine
#FROM --platform=linux/amd64 python:alpine
#FROM --platform=linux/arm64/v8 python:alpine 
#python:3.11.9-slim	
#python:3.12.5

# Common FinOps and Operational Container Labels
# Labels add metadata to an image. Add key value pairs 
LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL LOB="Line Of Business"
LABEL BU="Business Unit"
LABEL com.example.finops.cost-center="12345"
LABEL com.example.finops.project="my-project"
LABEL com.example.operational.team="devops"
LABEL com.example.operational.environment="production"
LABEL com.example.operational.csp="aws"
LABEL com.example.operational.region="us-east-1"
LABEL com.example.operational.version="6.27"
LABEL com.example.operational.component="front-end"
LABEL com.example.operational.release="stable"
LABEL com.example.operational.track="weekly"
LABEL com.example.operational.tier="front-end"
LABEL com.example.operational.rating="franchise-critical"
LABEL description="This text illustrates \
that label-values can span multiple lines."
LABEL org.opencontainers.image.authors="abishaiep@gmail.com"
LABEL org.opencontainers.deployment.id="12345"
LABEL org.opencontainers.deployment.environment="dev"
LABEL org.opencontainers.application.id="54321"
LABEL org.opencontainers.application.name="new-reef-revelations"
LABEL org.opencontainers.namespace="new-reef-revelations"
LABEL org.opencontainers.image.created="2024-08-31T19:00:00Z"
LABEL org.opencontainers.image.description="This is a sample Python application\
This text illustrates that label-values can span multiple lines."

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Set FLASK_APP to your main application script
ENV FLASK_APP=app.py  

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

COPY requirements.txt /app/
WORKDIR /app

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Copy dependencies.sh script
#COPY scripts/dependencies.sh /app/scripts/dependencies.sh

# Make the script executable
#RUN chmod +x /app/scripts/dependencies.sh

# Run the dependencies script
#RUN /app/scripts/dependencies.sh


# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.cache/pip to speed up subsequent builds.
# Leverage a bind mount to requirements.txt to avoid having to copy them into
# into this layer.
#RUN --mount=type=cache,target=/root/.cache/pip \
#    --mount=type=bind,source=requirements.txt,target=requirements.txt \
#    python -m pip install -r requirements.txt
#RUN --mount=type=cache,target=/root/.cache/pip \
 #   --mount=type=bind,source=requirements.txt,target=requirements.txt \
 #   --mount=type=bind,source=/scripts/dependencies.sh,target=/scripts/dependencies.sh \
 #   python -m pip install -r requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt
# Switch to the non-privileged user to run the application.
USER appuser

# Copy the source code into the container.
COPY . .

# Expose the port that the application listens on.
EXPOSE 5000

# Run the application.
#CMD flask run
CMD ["flask", "run"]

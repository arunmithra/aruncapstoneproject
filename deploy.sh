#!/bin/bash
docker-compose down || true
# Deploy the Docker container using docker-compose
docker-compose up -d

#!/bin/sh
docker-compose -f docker/docker-compose.yml --project-name XSSproxy "$@"

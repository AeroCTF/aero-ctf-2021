#!/bin/sh

gunicorn wsgi:app\
    --bind '0.0.0.0:8090' \
    -m 777 \
    --workers 16\
    --access-logfile -\
    --reload

#!/bin/bash
celery -A main worker --loglevel=INFO -c1 -Q normal,celery $@

FROM python:3.7

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=${PYTHONPATH}:/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./backend /app/

WORKDIR /app/

RUN pip install -r ./requirements.txt       
RUN chmod +x ./scripts/web.sh

USER nobody

CMD ["./scripts/web.sh"]

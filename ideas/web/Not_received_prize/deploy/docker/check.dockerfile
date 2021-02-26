FROM python:3.7

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=${PYTHONPATH}:/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


### selenium (chromedriver) dependencies (from https://github.com/joyzoursky/docker-python-chromedriver) ###
################
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
################



########## END CUSTOMIZE ##########

COPY ./check /app/

WORKDIR /app/

RUN pip install -r ./requirements.txt
RUN chmod +x ./run.sh            
RUN chmod +x ./main.py

CMD ["./run.sh"]

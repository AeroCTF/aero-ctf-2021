#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from os import getenv

class Config:

    REDIS_URL: str = 'redis://redis:6379/0'
    
    result_backend: str        = REDIS_URL
    broker_url: str                   = REDIS_URL
    task_send_sent_event: bool = True
    timezone: str              = 'Europe/Moscow'

    SQLALCHEMY_TRACK_MODIFICATIONS = False

    SQLALCHEMY_DATABASE_URI: str = 'postgresql+psycopg2://{user}:{passwd}@{host}:{port}/{db}'\
        .format(
            user   = getenv('POSTGRES_USER',     'ctf'),
            passwd = getenv('POSTGRES_PASSWORD', 'postgres'),
            host   = getenv('POSTGRES_HOST',     'pgsql'),
            port   = getenv('POSTGRES_PORT',      5432),
            db     = getenv('POSTGRES_DB',       'ctf')
        )
  
    ADM_LOGIN = getenv('ADM_LOGIN', 'ctf2021')
    ADM_PASS  = getenv('ADM_PASS',  'ctf2021')
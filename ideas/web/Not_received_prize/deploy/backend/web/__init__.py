#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from flask import Flask
from celery import Celery

celery: Celery = Celery()

def appFactory(name: str = 'xssProxy') -> Flask:

    from os import path

    from .config import Config
    from .models.flask import sa

    application: Flask = Flask(
        name,
        static_folder=path.join(path.dirname(__file__), 'static'),
        template_folder=path.join(path.dirname(__file__), 'templates')
    )

    application.config.from_object(Config)
    celery.config_from_object(application.config)

    sa.init_app(application)
    application.sa = sa

    routesRegisterer(application)
    return application


def routesRegisterer(application):
    from .auth import api as api_auth
    from .help import api as api_help
    from .admin import api as api_admin
    from .admin import api_other as api_admin_other
    from .help import api_other as api_help_other


    application.register_blueprint(api_auth, url_prefix='/api/auth')
    application.register_blueprint(api_help, url_prefix='/api/help')
    application.register_blueprint(api_admin, url_prefix='/api/admin')
    application.register_blueprint(api_admin_other, url_prefix='/admin')
    application.register_blueprint(api_help_other, url_prefix='/help')


    
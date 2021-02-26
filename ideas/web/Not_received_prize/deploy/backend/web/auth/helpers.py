# -*- coding: utf-8 -*-
import time
from functools import wraps

from flask import current_app, jsonify, session


def apiKey(l,t):
    from hashlib import md5
    return md5(f'{l}:{t}:ctf'.encode('utf-8')).hexdigest()

def check_auth(extend: bool = False):
    now = time.time()
    _login = session.get('login')
    api_key = session.get('api_key')
    valid_time = session.get('valid_time', 0)

    if now > valid_time:
        return False

    if _login and api_key:
        
        test_key = apiKey(_login, valid_time)

        if api_key != test_key:
            return False

    # Session prolongation
    if extend:
        valid_time = now + current_app.config['KEY_VALID_TIME']

    session['api_key'] = apiKey(_login, valid_time)
    session['valid_time'] = valid_time

    return True


def auth_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if check_auth(True):
            return f(*args, **kwargs)

        return jsonify({'error': 'no auth!'})

    return wrapper

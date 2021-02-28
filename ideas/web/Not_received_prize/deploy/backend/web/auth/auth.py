# -*- coding: utf-8 -*-
import time

from flask import Blueprint, jsonify, request, session
from flask import current_app as app

from .helpers import auth_required, apiKey

api = Blueprint(
    'api_auth', __name__, template_folder='templates',
)


@api.route('/', methods=['POST'], strict_slashes=False)
def _auth():
    """
    Request json:
    {
     action: "",
     username: "",
     password: ""
    }
    """

    try:
        import json
        data = json.loads(request.data)

    except json.decoder.JSONDecodeError:
        return jsonify({'error': 'Failed to parse JSON'})

    action = data.get('action', None)
    if not action:
        return jsonify({'error': 'Unknown auth method'})

    if action == 'auth':
        _login = data.get('login', None)
        _pass = data.get('password', None)

        if len(_login) <= 5:
            return jsonify({'error': 'Too short or empty login'})
        if len(_pass) <= 5:
            return jsonify({'error': 'Too short or empty password'})


        if app.config['ADM_LOGIN'] == _login and app.config['ADM_PASS'] == _pass:
            valid_time = time.time() + app.config['KEY_VALID_TIME']

            session['api_key'] = apiKey(_login,valid_time)
            session['login'] = _login
            session['valid_time'] = valid_time

            return jsonify({
            'status': 'Ok',
            'login': _login,
            'valid_time': valid_time
            })
        else:
            valid_time = time.time()-100
            session['login'] = _login
            session['valid_time'] = valid_time

            return jsonify({
                'error': 'Bad login or password',
                'login': _login,
                'valid_time': valid_time
                })

    elif action == 'logout':

        if 'login' in session:
            del session['login']
        if 'valid_time' in session:
            del session['valid_time']
        if 'api_key' in session:
            del session['api_key']

        return jsonify({
            'status': 'Ok'
        })

    return jsonify({'error': 'Unknown error'})

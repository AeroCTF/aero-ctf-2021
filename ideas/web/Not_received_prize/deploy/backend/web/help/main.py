# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify, request
from flask import current_app as app
from web import celery
import requests
from web.models.flask import sa
import web.models.flask  as db
import re

from sqlalchemy.exc import IntegrityError

api = Blueprint(
    'help_api', __name__, template_folder='templates',
)


def checkRecaptcha(response):
        url = 'https://www.google.com/recaptcha/api/siteverify?'
        url = url + 'secret=' + app.config['RECAPTCHA_PRIVATE_KEY']
        url = url + '&response=' +str(response)

        jsonobj = requests.get(url).json()
        
        if jsonobj['success']:
            return True
        else:
            return False        
    
@api.route('/add', methods=['POST'])
def _addHelpMsg():
    try:
        import json
        data = json.loads(request.data)

    except json.decoder.JSONDecodeError:
        return jsonify({'error': 'Failed to parse JSON'})

    captch = data.get('captch', None)
    if not captch:
        return jsonify({'error': 'Unknown param captch'})

    if not checkRecaptcha(captch):
        return jsonify({'error': 'Detect robot!)'})

    name = data.get('name', None)
    if not name:
        return jsonify({'error': 'Unknown param name'})

    msg = data.get('msg', None)
    if not msg:
        return jsonify({'error': 'Unknown param msg'})

    regex = r"<[^<>]*?>"
    msg = re.sub(regex, '', msg, 0, re.IGNORECASE | re.MULTILINE)


    addHelpMsg = db.HelpMsg(name=name, msg=msg)

    sa.session.add(addHelpMsg)

    try:
        from hashlib import sha256
        sa.session.flush()
        addHelpMsg.sha = sha256(f'CTF_{addHelpMsg.row_id}_2021'.encode('utf-8')).hexdigest()
        sa.session.commit()

        celery.send_task('tasks.adminRead', (addHelpMsg.sha,))
        return jsonify({'status': 'Thanks for your feedback!', 'id':addHelpMsg.sha})
    except IntegrityError as err:
        sa.session.rollback()
        print(str(err))
        return jsonify({'error': f"unknown error '{str(err)}'"})
    return jsonify({'error': "unknown error"})
        
    
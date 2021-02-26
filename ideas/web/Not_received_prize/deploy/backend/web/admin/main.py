# -*- coding: utf-8 -*-
import time

from flask import Blueprint, jsonify, request, session
from flask import current_app as app

from web.models.flask import sa
import web.models.flask  as db
#from web import tasks
from web.auth import auth_required

from sqlalchemy.exc import IntegrityError

api = Blueprint(
    'admin_api', __name__, template_folder='templates',
)

@api.route('/help/list', methods=['POST'])
@auth_required
def _helpMsgList():
    res = sa.session.query(db.HelpMsg) \
    .filter(db.HelpMsg.status == 0) \
    .order_by(db.HelpMsg.row_id.desc()) \
    .limit(10) \
    .all()

    return jsonify([{
            'id': getattr(row, 'sha', ''),
            'name': getattr(row, 'name', ''),
            'status': getattr(row, 'status', '')
        } for row in res])
        


#@api.route('/help/remove', methods=['POST'])
#@auth_required
#def _helpMsgRemove():
#    try:
#        import json
#        data = json.loads(request.data)
#
#    except json.decoder.JSONDecodeError:
#        return jsonify({'status': 'Failed to parse JSON'})
#
#    eid = data.get('id', None)
#    if not eid:
#        return jsonify({'status': 'Unknown param id'})
#
#    req = sa.session.query(db.HelpMsg).filter(db.HelpMsg.row_id == eid)
#    if req.count() == 1:
#        row = req.one()
#        sa.session.delete(row)
#
#        try:
#            sa.session.commit()
#        except IntegrityError as err:
#            sa.session.rollback()
#            print(str(err))
#            return jsonify({'status': f"unknown error '{str(err)}'"})
#        
#        return jsonify({'status': 'Ok'})
#    else:
#        return jsonify({'status': 'Not found host'})


#@api.route('/help/read', methods=['POST'])
#@auth_required
#def _helpMsgRead():
#    try:
#        import json
#        data = json.loads(request.data)
#
#    except json.decoder.JSONDecodeError:
#        return jsonify({'status': 'Failed to parse JSON'})
#
#    eid = data.get('id', None)
#    if not eid:
#        return jsonify({'status': 'Unknown param id'})
#
#    req = sa.session.query(db.HelpMsg).filter(db.HelpMsg.sha == eid)
#    if req.count() == 1:
#        row = req.one()
#        row.status = 1
#
#        try:
#            sa.session.commit()
#        except IntegrityError as err:
#            sa.session.rollback()
#            print(str(err))
#            jsonify({'status': f"unknown error '{str(err)}'"})
#        
#        return jsonify({
#            'id': getattr(row, 'row_id', ''),
#            'name': getattr(row, 'name', ''),
#            'msg': getattr(row, 'msg', '')
#        })
#    else:
#        return jsonify({'status': 'Not found host'})

@api.route('/pz/ex', methods=['POST'])
@auth_required
def _pzEx():
    from hashlib import sha256
    import random
    
    c = random.randint(0,3)

    a = random.randint(1,10)
    b = random.randint(1,10)

    solve = 0
    ex = ''

    session['s'] = salt =random.randint(1,100000)

    if c == 0:
        ex = f'{a} + {b} = ?'
        solve = a+b
    elif c==1:
        ex = f'{a} - {b} = ?'
        solve = a-b
    elif c==2:
        ex = f'{a} * {b} = ?'
        solve = a*b
    else:
        ex = f'{a*b} / {b} = ?'
        solve = a

    sh = sha256(f'CTF_solv_{solve}_{salt}_2021'.encode('utf-8')).hexdigest()

    out = jsonify({'ex': ex})
    out.set_cookie('solve', sh)
    return out    

@api.route('/pz/check', methods=['POST'])
@auth_required
def _pzCheck():
    from hashlib import sha256
    rsh = request.cookies.get('solve', None)

    if not rsh:
        return jsonify({'error': 'Error'})

    salt = session.get('s', None)
    if not salt:
        return jsonify({'error': 'Error'})

    try:
        import json
        data = json.loads(request.data)

    except json.decoder.JSONDecodeError:
        return jsonify({'error': 'Failed to parse JSON'})

    solve = data.get('solve', None)
    if not solve:
        return jsonify({'error': 'Unknown param solve'})

    sh = sha256(f'CTF_solv_{solve}_{salt}_2021'.encode('utf-8')).hexdigest()

    if (sh == rsh):
        return jsonify({'img': '/admin/img/175193053491407376ff47dc6e834673.png'})
    else:
        return jsonify({'img': '/admin/img/bf3adc3899a7b88bbedbe51271472a15.png'})
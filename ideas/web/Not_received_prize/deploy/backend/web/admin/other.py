# -*- coding: utf-8 -*-
import time

from flask import Blueprint, jsonify, request, session, render_template, redirect
from flask import current_app as app

from web.models.flask import sa
import web.models.flask  as db
#from web import tasks
from web.auth import check_auth

from sqlalchemy.exc import IntegrityError

api = Blueprint(
    'admin_api_other', __name__, template_folder='templates',
)


@api.route('/read.html', methods=['GET'])
def _helpMsgRead():
    if not check_auth(True):
        return render_template('badauth.html')

    data = request.args

    eid = data.get('id', None)
    if not eid:
        return render_template('read.html', name='None', msg='None')

    req = sa.session.query(db.HelpMsg).filter(db.HelpMsg.sha == eid)
    if req.count() == 1:
        row = req.one()
        row.status = 1

        try:
            sa.session.commit()
        except IntegrityError as err:
            sa.session.rollback()
            print(str(err))
            jsonify({'status': f"unknown error '{str(err)}'"})
        
        return render_template('read.html', name=getattr(row, 'name', ''), msg=getattr(row, 'msg', ''))

    else:
        return render_template('read.html', name='None', msg='None')

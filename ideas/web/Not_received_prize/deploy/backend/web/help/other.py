# -*- coding: utf-8 -*-
import time

from flask import Blueprint, request, render_template
from flask import current_app as app

from web.models.flask import sa
import web.models.flask  as db
#from web import tasks

api = Blueprint(
    'help_api_other', __name__, template_folder='templates',
)


@api.route('/read.html', methods=['GET'])
def _helpMsgRead():
    data = request.args

    eid = data.get('id', None)
    if not eid:
        return render_template('notfound.html', name='None', msg='None')

    req = sa.session.query(db.HelpMsg).filter(db.HelpMsg.sha == eid)
    if req.count() == 1:
        row = req.one()
        
        return render_template('read_user.html', name=getattr(row, 'name', ''), msg=getattr(row, 'msg', ''), status=getattr(row, 'status', ''))

    else:
        return render_template('notfound.html', name='None', msg='None')

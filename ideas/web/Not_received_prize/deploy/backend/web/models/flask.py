#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import functions as saf

sa = SQLAlchemy()

class HelpMsg(sa.Model):
    __tablename__ = 'help_msg'
    row_id = sa.Column('id', sa.Integer, primary_key=True)
    sha = sa.Column(sa.Text)
    name = sa.Column(sa.Text)
    msg = sa.Column(sa.Text)
    creat_date = sa.Column(sa.TIMESTAMP, server_default=saf.now())
    status = sa.Column(sa.Integer, default=0)
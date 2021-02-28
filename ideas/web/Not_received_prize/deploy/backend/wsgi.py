#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from web import appFactory
app = appFactory()

if __name__ == '__main__':
    app.run(
        host='127.0.0.1',
        port=8080,
    )

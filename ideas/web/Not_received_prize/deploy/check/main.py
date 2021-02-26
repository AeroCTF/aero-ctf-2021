#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from os import getenv
import sys

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import atexit
import signal
import random
import enum

import time

from celery import Celery
from config import Config

celery: Celery = Celery()
celery.config_from_object(Config)


ADM_LOGIN = getenv('ADM_LOGIN', 'ctf2021')
ADM_PASS  = getenv('ADM_PASS',  'ctf2021')


class Status(enum.Enum):
    OK      = 101
    CORRUPT = 102
    MUMBLE  = 103
    DOWN    = 104
    ERROR   = 110
    
    def __bool__(self):
        return self.value is Status.OK

def quit_driver(driver):   
    if driver:
        driver.quit()

def quit(driver, code, *args, **kwargs):
    quit_driver(driver)
    kwargs['file'] = sys.stderr
    print(*args, **kwargs)
    kwargs['file'] = sys.stdout
    print(*args, **kwargs)
    assert(type(code) == Status)
    return(code.value)

def quit_driver_wrapper(driver):
    def _quit_driver_internal(sig, frame):
        if driver:
            driver.quit()

    return _quit_driver_internal

@celery.task(name='tasks.adminRead')
def adminRead(id):
    chrome_options = webdriver.ChromeOptions()
    #chrome_options.add_argument(f'user-agent={user_agent}')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--disable-gpu')

    while True:
        # noinspection PyBroadException
        print('*')
        try:
            driver = webdriver.Chrome(options=chrome_options)
            # driver = webdriver.Remote(
            #    command_executor='http://hub:4444/wd/hub',
            #    desired_capabilities={'browserName': 'chrome', 'javascriptEnabled': True})
            print('=')
            driver.set_page_load_timeout(60)
        except:
            print('except')
            continue
        else:
            break
    print('+')
    signal.signal(signal.SIGINT, quit_driver_wrapper(driver))
    signal.signal(signal.SIGTERM, quit_driver_wrapper(driver))

    try:
        print('Strat')
        url = 'http://nginx/admin/index.html'
        driver.get(url)

        l = driver.find_element_by_id("login")
        l.send_keys(ADM_LOGIN)
        p = driver.find_element_by_id("password")
        p.send_keys(ADM_PASS)

        r = driver.find_element_by_id("btn")
        r.send_keys(Keys.RETURN)

        # print(driver.page_source)

        driver.get(f'http://nginx/admin/read.html?id={id}')

        time.sleep(25)
        print(len(driver.page_source))
        return quit(driver, Status.OK)
        print('Exit')
    except SystemExit:
        raise
    except BaseException as e:
        print('WTF?', e, type(e), repr(e))
        return quit(driver, Status.ERROR)


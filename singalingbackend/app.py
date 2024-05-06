
import datetime
import sched
import time
from flask import Flask, session
from flask_cors import cross_origin
from flask_socketio import SocketIO
from dotenv import load_dotenv
from flask_redis import Redis
from Signaling.signaling import SingnalingServer
import os
import eventlet 
eventlet.monkey_patch()


load_dotenv('.env')

app = Flask(__name__)
app.config["DEBUG"] = True
app.config["REDIS_HOST"] = os.environ.get('redishost')
app.config["REDIS_PORT"] = os.environ.get('redisport')
app.config["REDIS_PASSWORD"] = os.environ.get('redispassword')

redis = Redis(app)
socketio = SocketIO(app,async_mode = 'eventlet',cors_allowed_origins="*") # cors_allowed_origins="*" 

socketio.on_namespace(SingnalingServer('/singaling',rediscon=redis,socketio=socketio))


def clear_expired_session_data():
    
    now = datetime.utcnow()
    for key, data in session.items():
        if 'expires_at' in data and data['expires_at'] < now:
            session.pop(key, None)

def schedule_clearance(interval_seconds):
    
    s = sched.scheduler(time.time, time.sleep)
    def clear_session_data(sc):
        clear_expired_session_data()
        s.enter(interval_seconds, 1, clear_session_data, (sc,))
    s.enter(interval_seconds, 1, clear_session_data, (s,))
    s.run()





from functools import wraps
import jwt
from flask import request,jsonify
import os

def tokenRequired(f):
    @wraps(f)
    def decorated(*args,**kwargs):
        token = None
        
        if 'X-Access-Token' not in request.args:
            print('not token')
            jsonify({'Message' : 'Required Token Access'}),401
        
        elif 'X-Access-Token' in request.args:
            
            token = request.args.get('X-Access-Token')
        try:
            print(type(token))
            jwt.decode(token,os.environ.get('secretkey'),algorithms=["HS256"])
         
            return 1
        except Exception as e:
            print(e)
            jsonify({'Message' : 'Token is invalid'}),402
            return 0
            
        return f(*args,**kwargs)
    return decorated
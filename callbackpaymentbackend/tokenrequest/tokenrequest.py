import requests
import os

def getTokeRequest(userid):
    try:
        response = requests.get(os.environ.get("authurl"),params={"requeststatus" : "getToken","id" : userid})
        if response.status_code == 200:
            return {'status' : 1,'token' : response.json()['token']}
        else:
            return {'status' : 0}
    except:
        return {'status' : 0}

import requests
import os
def getClientinfo(clientid):
    try:

        clientinfo = requests.get(url=os.environ.get('authserviceurl'),params={'requeststatus' : 'getclientinfo','id' : clientid})
        if clientinfo.status_code == 200:
            
          
            return {'status' : 1,'name' : clientinfo.json()['name']}
    except Exception as e:
        print('errror is',e)
        return {'status' : 0}






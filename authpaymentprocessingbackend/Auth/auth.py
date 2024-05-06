import json
from bson import ObjectId
from flask_restful import Resource
from flask import Response, request
from GenToken.gentoken import genTokenKey
import gzip
from flask_cors import cross_origin
import os

class  UsersAuth(Resource):
    def __init__(self,mongocol):    
        super().__init__()
        self.mongocol = mongocol


    @cross_origin()
    def post(self):

        try:
   
            requestdata = request.data
            decodegzip = json.loads(gzip.decompress(requestdata).decode('utf-8'))
            if decodegzip['requeststatus'] == 'signup':
               
                result = self._signup(name=decodegzip['name'],gender=decodegzip['gender'],birthday=decodegzip['birthday'],deviceid=decodegzip['deviceid'])
                if result['status'] == 1:
                    genedtoken = genTokenKey(secretKey=os.environ.get('secretkey'),id=result['id'],name=decodegzip['name'])
                    return {'id' : result['id'],'token' : genedtoken},201
                else:
                    return {'Something is Wrong' : 0},500

                
                
            if decodegzip['requeststatus'] == 'checkalreadysignin':
                
                result = self._findDeviceId(deviceid=decodegzip['deviceid'])
                if result['status'] == 1:
                    gzippeddata = gzip.compress(json.dumps({'clientinfo' : result['clientinfo']}).encode('utf-8'))
                    response = Response(gzippeddata, content_type='application/json')
                    response.headers['Content-Encoding'] = 'gzip'
                    response.headers['Content-Length'] = len(gzippeddata)
                    return response,201
                elif result['status'] == 0:
                    gzippeddata = gzip.compress(json.dumps({'problem' : 0}).encode('utf-8'))
                    response = Response(gzippeddata, content_type='application/json')
                    response.headers['Content-Encoding'] = 'gzip'
                    response.headers['Content-Length'] = len(gzippeddata)
                    return response,300
            
         
                
        except Exception as e:
            print('error is',e)
            return {'Something is wrong' : 0},500
    @cross_origin()
    def get(self):
      
        try:
            requestdata = request.args
            
            if requestdata.get('requeststatus') == 'getclientinfo':
                result = self._findclient(requestdata.get('id'))
                if result['status'] != 0:
                    return {'name' : result['name']},200
                
                else:
                    print('error here is')
                    return {'status' : 'not found id'},500
            if requestdata.get('requeststatus') == 'getToken':
                result = genTokenKey(secretKey=os.environ.get('secretkey'),id=requestdata.get('id'),
                                     name=requestdata.get('name'))
                return {'token' : result},200
            if requestdata.get('resqueststatus') == 'rechecktranscationstatus':
                statusresult =self._checkClientTranscationStatus(userid=requestdata.get('id'))
                if statusresult == 1:
                    gettokenresult = genTokenKey(secretKey=os.environ.get('secretkey'),id=requestdata.get('id'),
                                     name=requestdata.get('name'))
                    return {'token' : gettokenresult,'status' : 1},200
                else:
                    return {'status' : 0},400

                

        except Exception as e:
            print('Error in get request',e)
            return {'status' : 0},500
        
    def _checkClientTranscationStatus(self,userid):
        try:
            result = self.mongocol.find({'_id' : ObjectId(userid)})
            for x in result:
                status = x['transcationstatus']
                if status == 1:
                    return 1
                elif status == 2:
                    return 2
                elif status == 3:
                    return 3
        except:
            return 0

    def _findclient(self,id):
        try:
            clientinfo = self.mongocol.find({'_id' : ObjectId(id)},{"_id" : 0,'name' : 1})
            for x in clientinfo:
            
                return {'name' : x['name'],'status' : 1}
                
         
        except Exception as e:
            return {'status' : 0}
    def _findDeviceId(self,deviceid):
        try:
            result = list(self.mongocol.find({'deviceid' : deviceid}))
            if len(result) == 0:
                return {'status' : 0}
            else:
                for x in result:
                    return {'status' : 1,'clientinfo' : {'name' : x['name'],'id' : str(x['_id']),'paidtimes' : x['paid-times']}}
            
        except Exception as e:
            print('error is findDeviceid',e)
            return {'status' : -1}

    def _signup(self,deviceid,name,gender,birthday):
        try:
            addinfo = self.mongocol.insert_one({'name' : name,'gender' : gender,'paid-times' : 0,
                'birthday' : birthday,
                'deviceid' : deviceid,
                'transcationstatus' : 1
                }
                )
            return {'id' : str(addinfo.inserted_id) ,'status' : 1}
        except Exception as e:
            print(e)
            return {'status' : 0}
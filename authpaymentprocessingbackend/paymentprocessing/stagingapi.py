import gzip
import json
from flask import Response, request
from flask_cors import cross_origin
from flask_restful import Resource
import requests as req
import os
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5
import base64
import uuid

class  StagingPaymentProcessing(Resource):
    def __init__(self):
        self.token = ""
        public_key = ("-----BEGIN PUBLIC KEY-----\n"+
        "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCUrslv2E7pQNlLCfawGT2j8aER+HDrZzLtBgDIH19tjMQwt1SBlFhaen9T0ylFLaTwGfRS6XiCmcdi34OSlD+tCr/lkWqYJaH/Xuz9aI60/d3aNmaF2yN+JF1a7A1jmJA8rlI4fdjbWWSnd0EdkngXwfyYpPl4CiPyGFVOnMlp2wIDAQAB"+
        "\n-----END PUBLIC KEY-----")

        self.public_key = RSA.import_key(public_key)

    @cross_origin()
    def post(self):
        try:
            requestdata = request.data
            decodegzip = json.loads(gzip.decompress(requestdata).decode('utf-8'))
            if decodegzip['requeststatus'] == '1':
                result = self.requestPay(providername=decodegzip['providername'],methodname=decodegzip['methodname'],userid=decodegzip["id"],userphonenumber=decodegzip["phone"],username=decodegzip["name"])
                if result['status'] == 1:
                    return self.returnGzip(data=result,statuscode=200)
                else:

                    return self.returnGzip(data=result,statuscode=400)


        except Exception as e:
            return self.returnGzip(data={'response' : 'Error','status' : 0},statuscode=400)
        
    def returnGzip(self,data,statuscode):
        gzippeddata = gzip.compress(json.dumps(data['response']).encode('utf-8'))
        response = Response(gzippeddata, content_type='application/json')
        response.headers['Content-Encoding'] = 'gzip'
        response.headers['Content-Length'] = len(gzippeddata)
        return response,statuscode



    def requestPay(self,providername,methodname,userid,userphonenumber,username):
        try:

            unique_id = uuid.uuid4().hex
            data = {
            "providerName": providername, 
            "methodName": methodname, 
            "totalAmount" : 4000, 
            "orderId":  f"{userid}--{unique_id[:8]}",   
            "customerPhone" : userphonenumber, 
            "customerName" : username, 
            "items" : "[{'amount' : '4000','name':'1 month','quantity':'1'}]" 
        }
            payload_encrypt = self.encryptPayload(message=json.dumps(data))
            if payload_encrypt != 'Error':

                response = req.post(os.environ.get('payurl'),
                                    headers={'Authorization': f'Bearer {self.token}'},data={'payload' : payload_encrypt})
                if response.status_code == 200:
                    
                    if response.json()['code'] == '003':
                        gettokenresult = self.requestPaymentToken()
                        if gettokenresult == 1:
                            return self.requestPay(providername,methodname,userid,userphonenumber,username)
                    else:

                        return {'status' : 1,'response' : response.json()}
            
                else:
                    return {'status' : 0,'response' : response.json()}
            else:
                return {'response' : 'error','status' : 0}
        except Exception as e:
            return {'response' : str(e),'status' : 0}
        
    
    def encryptPayload(self,message):
        try:

            data = message.encode()
            try:
                cipher_rsa = PKCS1_v1_5.new(self.public_key)
                res = []
                for i in range(0, len(data), 64):
                    enc_tmp = cipher_rsa.encrypt(data[i:i+64])
                    res.append(enc_tmp)
                cipher_text = b''.join(res)
            except Exception as e:
                return "Error"
            else:
                return base64.b64encode(cipher_text).decode()
        except Exception as e:
            return "Error"
  

    def requestPaymentToken(self):
        try:

            response = req.get(f"{os.environ.get('paymentbaseurl')}api/token?projectName={os.environ.get('projectname')}&apiKey={os.environ.get('merchantapi')}&merchantName={os.environ.get('merchantname')}")
            if response.status_code == 200:
                self.token = response.json()['response']['paymentToken']
                return 1
                #return {'status' : 1,'paymentToken' : response.json()['response']['paymentToken']}
            else:
                self.token = ""
                return "Problem"
        except Exception as e:
            return str(e)
            
            #return {'status' : 0}


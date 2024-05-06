import json
from flask import Flask, jsonify, render_template,request
from flask_restful import Api
from flask_socketio import SocketIO
from dotenv import load_dotenv
import eventlet


from flask_redis import Redis
from InitializeDb.mongodb_initialize import initializeMongoDB
from callback.decrypte_callback import DecrypteCallBack
from callback.paymentcallback import PaymentCallBack
import os

from transcationstatusrequest.requesttranscationstatus import updateTrascationStatus
eventlet.monkey_patch()

load_dotenv('.env')

app = Flask(__name__)
app.config["REDIS_HOST"] = "localhost"
app.config["REDIS_PORT"] = os.environ.get("redisport")
app.config["REDIS_PASSWORD"] = os.environ.get("redispassword")

mongodb = initializeMongoDB()
mongocol = mongodb['users']

redis = Redis(app)
socketio = SocketIO(app,async_mode = 'eventlet',cors_allowed_origins="*")

socketio.on_namespace(PaymentCallBack('/transcationstatus',socketio=socketio,redis=redis,mongocol=mongocol))



@app.route('/196677877912088432/payment/sucessurl', methods=['GET'])
def success():  
    # Render a success HTML page using Flask's render_template function
    return render_template('sucess.html')


@app.route('/106677800912088432/payment/callback',methods=['POST'])
def paymentCallback():
    if request.method == 'POST':
     
        notification_data = request.get_json()
        resultpaymentstatus = DecrypteCallBack().decrypt(key="d655c33205363f5450427e6b6193e466",decrData="mX2Ku+jslxIXDSQMxl3wzDclIiKilKlakN2149ijiV467m3lgyQTHuUlobdKDUrfxa5xlMg5HLj9MuO0WWssf+EjcRnPI8LMxU7LnM8lDYO52QeuU1bZ/0WV95jzJ1jOt6AJXNiSl+wu6wy6sQioCjVyyRXIpSug/4pokaXkIdQCpZo/YKa5QpVtSf1DucnCG/ESsxTw1sJQ39Pox8tdbcSvTPZrdFzcAyi/C8JFVtavTaUS8X1QndfKQphquZVhfKhVBA8etZaMwsoclfB8/e8mCSMUn+2s7/LYf9i9QHqlVdoS2ssTqJT+Rcfs9/Wa")
        resultstatus = json.loads(resultpaymentstatus)
        getuserid = resultstatus["merchantOrderId"]
        if resultstatus["transactionStatus"] == "SUCCESS":
            
            updatedresult = updateTrascationStatus(mongocol,1,getuserid.split("--")[0])
            if updatedresult == 1:

                '''
                update user data for transcation status.Here code to update.
                '''
                redis.rpush(f"{getuserid.split('--')[0]}id","1")
                return jsonify({'CallBackStatus' : 'SucessFully'}),200
            
        
        else:
            updatedresult = updateTrascationStatus(mongocol,3,getuserid.split("--")[0])
            if updatedresult == 1:
                
                redis.rpush(f"{getuserid.split('--')[0]}id","-1")
                return  jsonify({'CallBackStatus' : 'Fail'}),200




    

        

    




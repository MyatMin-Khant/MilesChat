from flask_socketio import Namespace, emit, join_room
import eventlet
from tokenrequest.tokenrequest import getTokeRequest

from transcationstatusrequest.requesttranscationstatus import updateTrascationStatus
class PaymentCallBack(Namespace):
    def __init__(self,namespace=None,socketio=None,redis=None,mongocol=None):
        self.socketio = socketio
        self.redis = redis
        self.mongocol = mongocol
        super().__init__(namespace)

    def on_connect(self):
        print('connect')
    def on_disconnect(self):
        print('dc')
    
    def on_transcation_start(self,data):
        updatetranscationstatus = updateTrascationStatus(mongodcol=self.mongocol,transcationstatus=2,userid=data[0])
        if updatetranscationstatus == 1:
            emit(f"{data[0]} updated 2")
            self.listening_transcationstatus(userid=data[0])
        else:
            emit(f"{data[0]} 0")
        
    def listening_transcationstatus(self,userid):
      
        self.redis.lpush(f"{userid}id","1")
        self.redis.expire(f"{userid}id",600)
        while True:
            listeningstatustranscation = self.redis.llen(f"{userid}id")
            checkexpire = self.redis.ttl(f"{userid}id")
          
            if listeningstatustranscation == 2 and checkexpire > 0:
                getstatus = self.redis.rpop(f"{userid}id").decode()
                self.redis.delete(f"{userid}id")
                if getstatus == "1":
                    gettokenresult = getTokeRequest(userid=userid)
                    if gettokenresult['status'] == '1':

                        emit(f"{userid} sucessfully transcation",[gettokenresult['token']])
                    else:
                        emit(f"{userid} fail transcation")

                else:
                    emit(f"{userid} fail transcation")
                break
                
            eventlet.sleep(1)
        
        
        
    
    
      
    
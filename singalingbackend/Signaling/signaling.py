from datetime import datetime,timedelta
import gzip
import json
from flask_socketio import Namespace,emit
from AuthToken import token_confirm
from flask_socketio import join_room, leave_room
from flask import request, session
import eventlet
from authrequest.authrequest import getClientinfo




class SingnalingServer(Namespace):
   
    def __init__(self,namespace=None,rediscon=None,socketio=None):
        

        self.socketio = socketio
        self.redis = rediscon
        self.keyval = 'mileschat:filter:room:' 
        super().__init__(namespace)
     
        


    def on_connect(self): 
        print('connect')


    def on_disconnect(self):
        print('dc')
        #self.deleteUserIdFromRedis(userid=session.get('userid')['userid'])
        #self.deleteUserIdSession(userid=session.get('userid')['userid'])
    
            
    def deleteUserIdFromRedis(self,userid):
        try:

            self.redis.lrem('mileschat:filter:room:man',-1,userid)
        except:
            pass

    def checkUserId(self,userid):
        if userid.encode('utf-8') in self.redis.lrange('mileschat:filter:room:man', 0, -1):
            return 1
        else:
            return 0

    def _checkRedKeys(self,key):
        return self.redis.ttl(key)
    def _checkLastClientOfferid(self,key,previousid):
        if previousid != '':

            clientid = self.redis.lindex(key,-1).decode()
            if clientid == previousid:
                return 0
            else:
                return 1
        else:
            return 1
    

    
    def _checkLenKeyId(self,key):
        return self.redis.llen(key)
        
    
        
    def _centerMeetConnector(self,clientid,chatfilterroom,previousid):
        # roomlen = self._checkLenKeyId(self.keyval+chatfilterroom)
        try:
            if self._checkRedKeys(self.keyval+chatfilterroom) == -2:

                
                
                self._offerMeetRemote(clientid=clientid,keyid=self.keyval+chatfilterroom)
            else:
        
                self._remoteMeetOffer(clientid=clientid,keyid=self.keyval+chatfilterroom,previousid=previousid)
        except Exception as e:
    
            self._centerMeetConnector(clientid=clientid,chatfilterroom=chatfilterroom,previousid=previousid)


    def _offerMeetRemote(self,clientid,keyid):
        _checkid = self.checkUserId(clientid)
        if _checkid == 1:
            roomid = f'roomid{clientid}'
            join_room(roomid)
            emit(f'{clientid} will offer 1090','Client not found yet',to=roomid)
        elif _checkid == 0:
            _createOffervir = self.redis.lpush(keyid,clientid)
            
            if _createOffervir != None:
                roomid = f'roomid{clientid}'
                join_room(roomid)
                self.addUserIdSession(userid=clientid)
                emit(f'{clientid} will offer 1090','Client not found yet',to=roomid)
            else:
            
                raise Exception()
       
    def _remoteMeetOffer(self,clientid,keyid,previousid):
        
        checkprevious = self._checkLastClientOfferid(key=keyid,previousid=previousid)
        if checkprevious == 1:

            _getOfferclientid = self.redis.rpop(keyid)

            if _getOfferclientid != None:
                
                roomid = f'roomid{_getOfferclientid.decode()}'
                join_room(roomid)
                self.addUserIdSession(userid=clientid)
                offerinfo = getClientinfo(_getOfferclientid.decode())
                remoteinfo = getClientinfo(clientid)
                gzipencodeofferinfo = gzip.compress(json.dumps(offerinfo).encode('utf-8'))
                gzipencoderemoteinfo = gzip.compress(json.dumps(remoteinfo).encode('utf-8'))
                if offerinfo['status'] == 1 and remoteinfo['status'] == 1:
                    emit(f'{_getOfferclientid.decode()} got remoteClient',[clientid,gzipencoderemoteinfo],to=roomid)
                    emit(f'{clientid} got offerClient',[ _getOfferclientid.decode(),roomid,gzipencodeofferinfo] ,to=roomid)
                else:
                  
                    emit(f'{_getOfferclientid.decode()} Something is wrong',to=roomid)
                    emit(f'{clientid} Something is wrong',to=roomid)
            
            else:
                raise Exception()
        elif checkprevious == 0:
            self._offerMeetRemote(clientid=clientid,keyid=keyid)
     
        

    def offer_to_remote(self,remoteid,offerinfo,roomid):
       
        emit(f'{remoteid} got offer request data',offerinfo, to=roomid)
       
    
    def answer_to_offer(self,offerid,answerinfo,roomid):
       
        emit(f'{offerid} got answer request data',answerinfo, to=roomid)
    
    def send_candiate_to_offer(self,offerid,candiate,roomid):
       
        emit(f'{offerid} got candiate',candiate,to=roomid)
    
    def stop_client_match(self,clientid,roomid,filter):
         removecon = self.redis.lrem(self.keyval+filter,-1,clientid)
         if removecon == 1 or removecon == 0 or removecon == None:
             self.close_roomid(roomid=roomid)
             self.deleteUserIdSession(userid=clientid)
             emit(f'{clientid} is sucessfully leave')
             
        
    
    def close_roomid(self,roomid):
      
        self.socketio.close_room(roomid,'/singaling')
     
    def close_roomid_clientid(self,roomid,clientid,filter):
        self.close_roomid(roomid=roomid)
        self.redis.lrem(self.keyval+filter,-2,clientid)
        self.deleteUserIdSession(userid=clientid)

    @token_confirm.tokenRequired
    def authToken(self):
        return 1
    
    def addUserIdSession(self,userid):
        #self.deleteUserIdSession(userid=userid)
        now = datetime.utcnow()
        expiration_time = now + timedelta(seconds=600)
        session['userid'] = {'userid' : userid,'expires_at' : expiration_time}
       

    def deleteUserIdSession(self,userid):
        try:
            session.pop(userid,None)
        except:
            pass
   
        

        

    def on_clients_request_precon(self,requestinfo):
        
        tokenAuth = self.authToken()
        if tokenAuth == 1 or requestinfo[-1] == 1:
        
            if  requestinfo[0] == '1':
                self.deleteUserIdFromRedis(userid=requestinfo[1])
                self.deleteUserIdSession(userid=requestinfo[1])
                eventlet.sleep(1)
                self._centerMeetConnector(clientid=requestinfo[1],chatfilterroom=requestinfo[2],previousid=requestinfo[3])
            if requestinfo[0] == '2':
                self.offer_to_remote(requestinfo[1],requestinfo[3],requestinfo[2])
            if requestinfo[0] == '3':
                self.answer_to_offer(requestinfo[1],requestinfo[3],requestinfo[2]) 
            if requestinfo[0] == '4':
                self.send_candiate_to_offer(requestinfo[1],requestinfo[3],requestinfo[2])
            if requestinfo[0] == '-1':
                self.close_roomid(requestinfo[1])
            if requestinfo[0] == '-2':
                self.close_roomid_clientid(requestinfo[1],requestinfo[2],requestinfo[3])
            if requestinfo[0] == '-3':
                self.stop_client_match(requestinfo[1],requestinfo[2],requestinfo[3])
            if requestinfo[0] == '-4':
                self.deleteUserIdFromRedis(userid=requestinfo[1])
        else:
            print('denied token')   
            if requestinfo[0] == '1':
                emit(f'{requestinfo[1]} is over subtime')


            

    
        
        


        
        


    



    



    
        
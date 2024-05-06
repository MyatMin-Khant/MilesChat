import datetime
import jwt 


def genTokenKey(secretKey,id,name):

    token = jwt.encode({
        'sub' : id,
        'name' : name,
        'exp' : datetime.datetime.utcnow() + datetime.timedelta(days=30)
    },secretKey,algorithm="HS256")
    return  token 
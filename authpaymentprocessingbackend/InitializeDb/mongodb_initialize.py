import json
import  pymongo
import os
import urllib.parse


_cerdential = None
def initializeMongoDB():
    global _cerdential
    _cerdential = _getCredentials()
    mongodbclient = pymongo.MongoClient(f"mongodb://{_cerdential['username']}:{_cerdential['password']}@{os.environ.get('mongodbhost')}:{int(os.environ.get('mongodbport'))}/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+1.10.3",connect=False)


    db = mongodbclient[os.environ.get('targetdb')]
    return db

def _getCredentials():
    _loadedcre =  json.loads(os.environ.get("mongodbuserauth"))
    return {'username' : urllib.parse.quote_plus(_loadedcre['username']),'password' : urllib.parse.quote_plus(_loadedcre['password'])}
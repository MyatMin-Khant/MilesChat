from bson import ObjectId
def updateTrascationStatus(mongodcol,transcationstatus,userid):
    try:
        updatedvalue = getExistingValue(ObjectId(userid),mongodcol)
        if updatedvalue == 1:
            return 1
        elif updatedvalue  == 2:

            result = mongodcol.update_one({"_id" : ObjectId(userid)},{ "$set": { "transcationstatus": transcationstatus} })
            if result.modified_count > 0:
                return 1
            else:
                return 0
        elif updatedvalue == 0:
            return 0
    except:
        return 0
    
def getExistingValue(userid,mongocol):
    try:
        result = mongocol.find({'_id' : userid})
        for x in result:
            if x['transcationstatus'] == 2:
                return 1
            else:
                return 2
    except:
        return 0
    


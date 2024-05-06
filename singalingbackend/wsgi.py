from app import  schedule_clearance, socketio,app
from flask_cors import CORS

if __name__ == '__main__':
    #schedule_clearance(1200) 
    CORS(app)
    socketio.run(app)
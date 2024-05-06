from flask_cors import CORS
from app import socketio,app
if __name__ == '__main__':
    #schedule_clearance(1200) 
    CORS(app)
    socketio.run(app)
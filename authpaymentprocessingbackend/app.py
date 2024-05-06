from flask import Flask
from flask_restful import Resource, Api
from Auth.auth import UsersAuth
from InitializeDb.mongodb_initialize import initializeMongoDB
from dotenv import load_dotenv

from paymentprocessing.stagingapi import StagingPaymentProcessing

load_dotenv('.env')
app = Flask(__name__)
api = Api(app)

mongodb = initializeMongoDB()
mongocol = mongodb['users']

api.add_resource(UsersAuth,'/usersauth',resource_class_kwargs={'mongocol' : mongocol})
api.add_resource(StagingPaymentProcessing,'/payment')







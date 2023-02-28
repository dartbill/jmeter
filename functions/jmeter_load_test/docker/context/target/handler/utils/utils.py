import logging, os
logger = logging.getLogger()

# easikit imports
from easiutils import exceptions as er


def getmessage(message=None):
    if message == None:
      message = "Hello! Your world executed successfully from: " + os.getcwd()

    return message

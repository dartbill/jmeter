import logging
logger = logging.getLogger()

# easikit imports
from easiutils import exceptions as er

# project specific imports
from handler.utils import utils

def retrieve(event=None):
    mssg = utils.getmessage()
    rslt = compose_entity(mssg, event)

    return rslt

def compose_entity(mssg, event):
    entity = {
        "message": mssg,
        "event": event
    }
    return entity


def create(payload):
    try:
        rslt = dict(payload)

    except Exception as ex:
        raise er.UclError(ex)

    return rslt
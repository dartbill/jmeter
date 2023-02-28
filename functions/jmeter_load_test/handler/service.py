import logging
logger = logging.getLogger()

# easikit imports
from easiutils import exceptions as er

# project specific imports
from handler.model import entity
 
def get_entity(event=None):
    try:
        data = entity.retrieve(event)
        resp = { "body": data, "status": 200 }

    except er.UclError as ex:
        resp = ex

    except Exception as ex:
        resp = er.UclError(ex)

    return resp


def post_entity(payload):
    try:
        data = entity.create(payload)
        resp = {
            "body": None,
            "status": "201",
            "content": "text/plain"
        }

    except er.UclError as ex:
        resp = ex

    except Exception as ex:
        resp = er.UclError(ex)

    return resp

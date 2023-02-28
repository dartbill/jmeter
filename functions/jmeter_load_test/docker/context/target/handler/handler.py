import logging
logger = logging.getLogger()

# easikit imports
from easiutils import response, exceptions as er

# project specific imports 
from handler import service as sv
 
 
def handler(event, context={}):
    req = event["easikit"]["request"]

    if req["method"] == "GET":
        resp = sv.get_entity(event)

    elif req["route"] == "POST /entity":
        resp = sv.post_entity(req["body"])
    
    else:
        resp = er.RequestError(type=er.REQ_UNHANDLED_ROUTE, log=req)

    return response.response(**resp, req=req)

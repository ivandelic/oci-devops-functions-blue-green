import urllib.request
import logging

logging.basicConfig(level=logging.DEBUG)

def getApi(address):
    try:
        response = urllib.request.urlopen(address).read()
    except Exception as e:
        logging.getLogger().error("Unable to load data from " + address)
    return response
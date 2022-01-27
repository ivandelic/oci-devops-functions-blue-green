import io
import json
import logging
import collections
import os
import apimanager
from fdk import response

logging.basicConfig(level=logging.DEBUG)

defargs = {
    'url': 'https://api.coindesk.com/v1/bpi/currentprice.json'
}


def handler(ctx, data: io.BytesIO = None):
    if data is not None:
        payload = json.loads(data.getvalue())
        args = collections.ChainMap(payload, os.environ, defargs)
    else:
        args = collections.ChainMap(os.environ, defargs)
    uri = args.get("url")
    logging.getLogger().debug("Requested URI\n" + uri)
    content = json.loads(apimanager.getApi(uri))
    usd_price = content["bpi"]["USD"]["rate_float"]
    eur_price = content["bpi"]["EUR"]["rate_float"]
    return response.Response(ctx, response_data=json.dumps({"usd": usd_price, "eur": eur_price}), headers={"Content-Type": "application/json"})

if __name__ == "__main__":
    handler(None, None)
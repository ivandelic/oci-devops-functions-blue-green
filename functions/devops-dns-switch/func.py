import io
import json
import logging
import oci
import collections
import os
import json

from fdk import response

defargs = {
    'BLUE_FQDN': '',
    'GREEN_FQDN': '',
    'ZONE_ID': '',
    'DOMAIN': ''
}

def handler(ctx, data: io.BytesIO = None):
    payload = json.loads(data.getvalue())
    args = collections.ChainMap(payload, os.environ, defargs)

    signer = oci.auth.signers.get_resource_principals_signer()

    dns_client = oci.dns.DnsClient(config={}, signer=signer)

    domain_records = dns_client.get_domain_records(
        zone_name_or_id=args.get("ZONE_ID"),
        domain=args.get("DOMAIN"))

    active_item = domain_records.data.items[0]
    active_fqdn = active_item.rdata.strip()

    if active_fqdn == args.get("BLUE_FQDN"):
        next_fqnd = args.get("GREEN_FQDN")
    elif active_fqdn == args.get("GREEN_FQDN"):
        next_fqnd = args.get("BLUE_FQDN")
    else:
        logging.getLogger().error('Wrong Active FQDN {active}, while expected {blue} or {green}'.format(active=active_fqdn, blue=args.get("BLUE_FQDN"), green=args.get("GREEN_FQDN")))
        return "false"

    dns_client.update_domain_records(
        update_domain_records_details=oci.dns.models.UpdateDomainRecordsDetails(
            items=[
                oci.dns.models.RecordDetails(
                    domain=active_item.domain,
                    rdata=next_fqnd,
                    rtype=active_item.rtype,
                    ttl=active_item.ttl)]),
        zone_name_or_id=args.get("ZONE_ID"),
        domain=args.get("DOMAIN"))

    return "true"
import io
import json
import logging
import oci
import collections
import os
import json

from fdk import response

defargs = {
    'BLUE_STACK_ID': '',
    'BLUE_FQDN': '',
    'GREEN_STACK_ID': '',
    'GREEN_FQDN': '',
    'BUILD_ID': '',
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
        stack_id = args.get("GREEN_STACK_ID")
        next_fqnd = args.get("GREEN_FQDN")
    elif active_fqdn == args.get("GREEN_FQDN"):
        stack_id = args.get("BLUE_STACK_ID")
        next_fqnd = args.get("BLUE_FQDN")
    else:
        raise ValueError('Wrong Active FQDN {active}, while expected {blue} or {green}'.format(active=active_fqdn, blue=args.get("BLUE_FQDN"), green=args.get("GREEN_FQDN")))

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


    '''
    client = oci.resource_manager.ResourceManagerClient(config={}, signer=signer)

    job_details=oci.resource_manager.models.CreateJobDetails(
        stack_id=args.get("STACK_ID"),
        job_operation_details=oci.resource_manager.models.CreateApplyJobOperationDetails(
            operation="APPLY",
            execution_plan_strategy="AUTO_APPROVED"))

    job = client.create_job(job_details)


    logging.getLogger().info("Inside Python Hello World function")*/
    '''

    return response.Response(ctx, response_data=json.dumps({"message": "Completed {0}".format(args.get("BUILD_ID"))}), headers={"Content-Type": "application/json"})
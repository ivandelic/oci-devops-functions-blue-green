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
    elif active_fqdn == args.get("GREEN_FQDN"):
        stack_id = args.get("BLUE_STACK_ID")
    else:
        logging.getLogger().error('Wrong Active FQDN {active}, while expected {blue} or {green}'.format(active=active_fqdn, blue=args.get("BLUE_FQDN"), green=args.get("GREEN_FQDN")))
        return "false"

    rm_client = oci.resource_manager.ResourceManagerClient(config={}, signer=signer)

    logging.getLogger().info('Started applying stack {active}'.format(active=stack_id))

    job_details=rm_client.create_job(
        create_job_details=oci.resource_manager.models.CreateJobDetails(
            stack_id=stack_id,
            job_operation_details=oci.resource_manager.models.CreateApplyJobOperationDetails(
                operation="APPLY",
                execution_plan_strategy="AUTO_APPROVED")))

    job_id = job_details.data.id
    job_response = rm_client.get_job(job_id)
    oci.wait_until(rm_client, job_response, 'lifecycle_state', 'SUCCEEDED')

    logging.getLogger().info('Finished applying stack {active}'.format(active=stack_id))

    return "true"
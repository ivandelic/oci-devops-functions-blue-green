import io
import json
import logging
import oci
import collections
import os
import json

from fdk import response

defargs = {
    'STACK_ID': '',
    'OPERATION': 'APPLY'
}

def handler(ctx, data: io.BytesIO = None):
    payload = json.loads(data.getvalue())
    args = collections.ChainMap(payload, os.environ, defargs)

    signer = oci.auth.signers.get_resource_principals_signer()
    client = oci.resource_manager.ResourceManagerClient(config={}, signer=signer)

    job_details=oci.resource_manager.models.CreateJobDetails(
        stack_id=args.get("STACK_ID"),
        job_operation_details=oci.resource_manager.models.CreateApplyJobOperationDetails(
            operation="APPLY",
            execution_plan_strategy="AUTO_APPROVED")
    )

    job = client.create_job(job_details)


    logging.getLogger().info("Inside Python Hello World function")

    return response.Response(ctx, response_data=json.dumps({"message": "Started {0}".format(args.get("STACK_ID"))}), headers={"Content-Type": "application/json"})
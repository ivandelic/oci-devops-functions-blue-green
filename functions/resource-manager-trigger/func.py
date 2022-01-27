import io
import json
import logging
import oci

from fdk import response


def handler(ctx, data: io.BytesIO = None):
    name = "World"
    try:
        body = json.loads(data.getvalue())
        name = body.get("name")
    except (Exception, ValueError) as ex:
        logging.getLogger().info('error parsing json payload: ' + str(ex))

    signer = oci.auth.signers.get_resource_principals_signer()
    client = oci.resource_manager.ResourceManagerClient(config={}, signer=signer)

    job_details=oci.resource_manager.models.CreateJobDetails(
        stack_id="ocid1.ormstack.oc1.eu-frankfurt-1.aaaaaaaakrpjgarch5lthl5xqaufghfz4inuzdkoxgx4aa67u7glfzxu5zwa",
        job_operation_details=oci.resource_manager.models.CreateApplyJobOperationDetails(
            operation="APPLY",
            execution_plan_strategy="AUTO_APPROVED"))

    job = client.create_job(job_details)


    logging.getLogger().info("Inside Python Hello World function")
    return response.Response(
        ctx, response_data=json.dumps(
            {"message": "Hello {0}".format(name)}),
        headers={"Content-Type": "application/json"}
    )
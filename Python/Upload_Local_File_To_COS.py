import requests
import json


def upload_file_to_COS(local_file_path, COS_bucket_file_url, headers):
    with open(local_file_path, 'rb') as f:
        upload_response = requests.put(COS_bucket_file_url, headers=headers, data=f)
    print(upload_response)


if __name__ == "__main__":

	"""
	Fetch Access Token
	"""
	token_url = 'https://iam.cloud.ibm.com/oidc/token'
	headers = {
	    'Accept': 'application/json',
	    'Content-Type': 'application/x-www-form-urlencoded'
	}
	data = {
	    # create API key here: https://cloud.ibm.com/iam/apikeys
	    'apikey': '',
	    'response_type': 'cloud_iam',
	    'grant_type': 'urn:ibm:params:oauth:grant-type:apikey'
	}
	auth_response = requests.post(token_url, headers=headers, data=data)
	auth_JSON_py_dict = json.loads(auth_response.text)

	"""
	Upload Local File to COS Bucket
	"""
	endpoint = 's3.us-south.cloud-object-storage.appdomain.cloud'
	bucket_name = 'this-is-a-bucket'
	bucet_file_name = 'results.csv'
	COS_bucket_file_URL = f"https://{endpoint}/{bucket_name}/{bucket_file_name}"

	headers = {
	    'Authorization': f"bearer {auth_JSON_py_dict['access_token']}",
	    'Content-Type': 'text/csv'
	}

	upload_file_to_COS(local_file_path=r"./results.csv", COS_bucket_file_url=COS_bucket_file_URL, headers=headers)
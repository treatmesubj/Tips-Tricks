# adapted from https://gist.github.com/JeffPaine/3145490?permalink_comment_id=2226141#gistcomment-2226141
import os
import json
import requests
import argparse
import keyring
import keyring.util.platform_ as keyring_platform


def create_github_issue(
        username, password, keyringy,
        repo_owner, repo_name,
        title, body=None, labels=None
        ):
    # url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/issues"
    url = f"https://github.ibm.com/api/v3/repos/{repo_owner}/{repo_name}/issues"
    session = requests.Session()
    if args.keyringy:
        session.auth = (username, keyring.get_password(service_name="github.ibm.com", username=username))
    else:
        session.auth = (username, password)
    issue = {
        'title': title,
         'body': body,
         'labels': labels
    }
    r = session.post(url, json.dumps(issue))
    if r.status_code == 201:
        print (f"Successfully created Issue: {title}")
    else:
        print ("Could not create Issue: {title}")
        print ('Response: ', r.content)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--username', '-u', required=True, action="store")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--keyringy', '-k', help="keyring",  default=None, action="store_true")
    group.add_argument('--password', '-p', help="personal access token w/ repo scope", default=None, action="store")
    parser.add_argument('--repo_owner', '-o', required=True, action="store")
    parser.add_argument('--repo_name', '-n', required=True, action="store")
    parser.add_argument('--title', '-t', required=True, action="store")
    parser.add_argument('--body', '-b', required=False, default=None, action="store")
    parser.add_argument('--labels', '-l', required=False, default=[], nargs='?', action="store")
    args = parser.parse_args()

    create_github_issue(
        args.username, args.password, args.keyringy,
        args.repo_owner, args.repo_name,
        args.title, args.body, args.labels
        )

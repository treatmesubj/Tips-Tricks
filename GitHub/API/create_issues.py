# adapted from https://gist.github.com/JeffPaine/3145490?permalink_comment_id=2226141#gistcomment-2226141
import os
import json
import requests
import argparse


def make_github_issue(
        username, password,
        repo_owner, repo_name,
        title, body=None, labels=None
        ):
    # url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/issues"
    url = f"https://github.ibm.com/api/v3/repos/{repo_owner}/{repo_name}/issues"
    # Create an authenticated session to create the issue
    session = requests.Session()
    session.auth = (username, password)
    # Create our issue
    issue = {
        'title': title,
         'body': body,
         'labels': labels
    }
    # Add the issue to our repository
    r = session.post(url, json.dumps(issue))
    if r.status_code == 201:
        print ('Successfully created Issue {0:s}'.format(title))
    else:
        print ('Could not create Issue {0:s}'.format(title))
        print ('Response:', r.content)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--username', '-u', required=True, action="store")
    parser.add_argument('--password', '-p', required=True, action="store")
    parser.add_argument('--repo_owner', '-o', required=True, action="store")
    parser.add_argument('--repo_name', '-n', required=True, action="store")
    parser.add_argument('--title', '-t', required=True, action="store")
    parser.add_argument('--body', '-b', required=True, default=None, action="store")
    parser.add_argument('--labels', '-l', required=True, default=None, nargs='?', action="store")
    args = parser.parse_args()

    make_github_issue(
        args.username, args.password,
        args.repo_owner, args.repo_name,
        args.title, args.body, args.labels
        )

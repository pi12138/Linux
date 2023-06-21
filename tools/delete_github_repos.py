"""
需要先申请 github 的 token 并且该 token 需要有 delete_repo 权限
在 GitHub 上导航到 "Settings" > "Developer settings" > "Personal access tokens"，然后点击 "Generate new token"
"""

import requests


def main():
    token = input("Enter token or token file: ")
    if "/" in token:
        with open(token, "r") as f:
            token = f.read()
        token = token.strip()
    headers = {'Authorization': f'token {token}'}
    response = requests.get('https://api.github.com/user/repos', headers=headers)
    repos = response.json()

    name_to_del_url = dict()
    print("repos: ")
    for repo in repos:
        repo_name = repo['name']
        repo_owner = repo['owner']['login']
        url = f'https://api.github.com/repos/{repo_owner}/{repo_name}'
        name_to_del_url[repo_name] = url

        print("  " + repo_name)
    
    repos = input("Enter multiple names separated by commas: ")
    repos = repos.split(",")
    for repo in repos:
        url = name_to_del_url[repo]
        resp = requests.delete(url, headers=headers)
        print(f"Delete repo {repo}. status_code: {resp.status_code}")

if __name__ == "__main__":
    main()
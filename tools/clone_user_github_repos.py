import requests
import os

def main():
    username = input("input username: ")
    url = "https://api.github.com/users/{username}/repos".format(username=username)
    resp = requests.get(url=url)
    repo_name_to_ssh_url = dict()

    if resp.status_code == 200:
        print("repo list: ")
        for i in resp.json():
            print("  " + i["name"])
            repo_name_to_ssh_url[i["name"]] = i["ssh_url"]
        
        opt = input("options: \n\tdownload all(1)\n\tdownload one(2)\n\tdownload many(3)\n\tinput: ")
        if opt == "1":
            for i in repo_name_to_ssh_url.values():
                os.system(f"git clone {i}")
        elif opt == "2":
            name = input("input name: ")
            os.system(f"git clone {repo_name_to_ssh_url[name]}")
        elif opt == "3":
            names = input("Enter multiple names separated by commas: ")
            names = names.split(",")
            for i in names:
                os.system(f"git clone {repo_name_to_ssh_url[i]}")
        else:
            print(f"wrong options. {opt}")

    else:
        print(f"status code is {resp.status_code}")

if __name__ == "__main__":
    main()
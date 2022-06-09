#!/usr/bin/env python3

"""
模拟wget
"""

import requests
import json
import sys


def request_url(method, url):
    method = method.lower()
    method_map = {
        'get': requests.get
    }
    func = method_map[method]
    return func(url)


def handle_response(response: requests.Response):
    print(f'状态码: {response.status_code}')
    print(f'响应头:\n{json.dumps(dict(response.headers), indent=4)}')
    try:
        body = json.dumps(json.loads(response.text), indent=4)  # load 在 dump 是为了格式化显示
    except json.JSONDecodeError:
        body = response.text
    print(f'响应体:\n{body}')


def main():
    argv = sys.argv
    method, url = argv[1], argv[2]
    response = request_url(method, url)
    handle_response(response)


if __name__ == "__main__":
    main()

#!/usr/bin/env python
import re
import json
import os
import requests
import yaml
import pyaml
import subprocess

DOCKER_TOKEN = ""
DOCKER_CFG = os.path.join(os.environ['HOME'], ".docker", "config.json")
with open(DOCKER_CFG) as file:
    DOCKER_TOKEN = json.load(file)["auths"]["https://index.docker.io/v1/"]["auth"]

def get_tags(repo):
    '''Query dockerhub for available tags for an image'''
    resp = requests.get('https://auth.docker.io/token?service=registry.docker.io&scope=repository:{}:pull'.format(repo),
                        headers={'Authorization': 'Basic ' + DOCKER_TOKEN})
    token = resp.json()['token']
    return requests.get("https://index.docker.io/v2/{}/tags/list".format(repo),
                        headers={'Authorization': 'Bearer ' + token,
                                 'Accept': 'application/json'}).json()['tags']

VERSIONS_FILE = os.path.join('vars', 'versions.yml')

if __name__ == '__main__':
    VERSIONS = None
    with open(VERSIONS_FILE, 'r') as file:
        VERSIONS = yaml.safe_load(file)
    print(VERSIONS)

    with open(VERSIONS_FILE, 'w') as file:
        pyaml.dump(VERSIONS, file, explicit_start=True)
        print("Updated {}".format(VERSIONS_FILE))

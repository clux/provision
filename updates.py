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

#def get_node_version():
#    '''
#    Find latest nodejs LTS version
#    '''
#    resp = requests.get("https://nodejs.org/download/release/index.json")
#    last_lts = [v for v in resp.json() if v['lts']][0]
#
#    return last_lts['version']

def get_sublime_build():
    '''Hacky parsing of sublime/3 page to get latest build'''
    resp = requests.get("http://www.sublimetext.com/3")
    match = re.search(r'Build (\d{4,5})', resp.text)
    return int(match.group(1))


def get_stable_rust_version():
    '''Hacky parsing of rust-lang download page to get latest stable version'''
    resp = requests.get("https://www.rust-lang.org/en-US/install.html")
    match = re.search(r'(\d+\.\d+\.\d+)', resp.text)
    return match.group(1)

if __name__ == '__main__':
    VERSIONS = None
    with open(VERSIONS_FILE, 'r') as file:
        VERSIONS = yaml.safe_load(file)
    print(VERSIONS)

    VERSIONS['subl_build'] = get_sublime_build()
    VERSIONS['rust_ver'] = get_stable_rust_version()
    #VERSIONS['node'] = get_node_version()

    with open(VERSIONS_FILE, 'w') as file:
        pyaml.dump(VERSIONS, file, explicit_start=True)
        print("Updated {}".format(VERSIONS_FILE))

from requests import get, RequestException
from json import loads
from subprocess import run, PIPE, DEVNULL
import re

URL = "https://api.github.com/repos/magefree/mage/releases/latest"
OVERLAY = "./overlays/xmage.nix"
RE_FUNC = lambda spaces, string: rf'(\s{{{str(spaces)}}}{string}\s=\s")(.*)(")'
VER_RE=re.compile(RE_FUNC(2, "version"))
URL_RE=re.compile(RE_FUNC(2, "url"))
SHA256_RE=re.compile(RE_FUNC(6, "sha256"))

def sub_overlay(pattern, string):
    with open(OVERLAY) as i:
        input = i.read()
        with open(OVERLAY, "w") as o:
                o.write(re.sub(pattern, rf"\1{string}\3", input, re.M))


def __main__():
    try:
        response = get(URL)
        response.raise_for_status()
        json_data = response.json()
    except RequestException as e:
        print(f"An error occured: {e}")
    except ValueError as e:
        print(f"JSON decoding error: {e}")

    release_ver = json_data["tag_name"]
    
    with open(OVERLAY) as i:
        if re.search(VER_RE, i.read()).group(2) == release_ver:
            return

    zip_name = json_data["assets"][0]["name"]
    zip_url = json_data["assets"][0]["browser_download_url"]
    run(["wget", zip_url], stdout=DEVNULL)
    sha256_sum = run(["nix", "hash", "file", zip_name], stdout=PIPE).stdout.strip().decode("utf-8")
    run(["rm", zip_name])


    sub_overlay(VER_RE, release_ver)
    sub_overlay(URL_RE, zip_url)
    sub_overlay(SHA256_RE, sha256_sum)
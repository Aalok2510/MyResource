import socket
import argparse

parser = argparse.ArgumentParser(description='A python tool to check for subdomain takeover.')
parser.add_argument('-l', '--list', help='Domain name of the taget [ex : hackerone.com]', required=True)
args = parser.parse_args()


def host(url):
    ipaddr = socket.gethostbyname(url)
    return(ipaddr)


with open(args.list, "r") as fp:
    a = fp.readlines()
    for x in a:
        if 'https://' in x:
            url = x.replace("https://", "")
            print(host(url.strip()))
        if 'http://' in x:
            url = x.replace("http://", "")
            print(host(url.strip()))

#!/bin/python3

import argparse
from http import HTTPStatus
import http.server as hs
import http.client as hc
import urllib.request as ur
import shutil

UAGENT = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1"

args = None

class UserAgentMangler(hs.BaseHTTPRequestHandler):

    def do_GET(self):
        self.handle_req('GET')

    def do_HEAD(self):
        self.handle_req('HEAD')

    def handle_req(self, req_type):
        con = None
        con_open = False
        try:
            # inits connection to args.server (e.g: elpa.gnu.org)
            con = hc.HTTPConnection(args.server)
            con.putrequest(req_type, self.path)
            con_open = True

            # transfers headers to the new connection.
            # THe user agent is changed to UAGENT
            # Note: converting to string is stupid, but...........
            for h in str(self.headers).splitlines():
                print(h)
                if h == "":
                    continue
                hname, hvalue = h.split(': ')

                if hname == "User-Agent":
                    con.putheader(hname, UAGENT)
                else:
                    con.putheader(hname, hvalue)
            con.endheaders()

            # Returns the response's headers from args.server to the caller
            response = con.getresponse()
            self.send_response(HTTPStatus.OK)
            for h,v in response.getheaders():
                self.send_header(h,v)
            self.end_headers()

            # Returns the response's body from REPO to the caller
            shutil.copyfileobj(response, self.wfile)

        finally:
            if con_open:
                con.close()
                con_open = False

def parse_options() -> None:
    parser = argparse.ArgumentParser(description="HTTP proxy wich mangles UserAgent")

    parser.add_argument("server", type=str, help="The address of the intended server")
    parser.add_argument("-p", "--port", type=int, default=0, help="The local port the mangler binds to")
    parser.add_argument("-b", "--bind", type=str, default='', help="The local interface's ip address the mangler binds to")

    global args
    args = parser.parse_args()

def main() -> None:
    #Create a web server and define the handler to manage the
    #incoming request
    server = hs.HTTPServer((args.bind, args.port), UserAgentMangler)

    print('Started httpserver on ' , server.socket.getsockname())

    #Wait forever for incoming htto requests
    server.serve_forever()

if __name__ == '__main__':
    try:
        parse_options()
        main()

    except KeyboardInterrupt:
        print('^C received, shutting down the web server')
        server.socket.close()

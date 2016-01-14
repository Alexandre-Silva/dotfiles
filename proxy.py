#!/bin/python3

from http import HTTPStatus
import http.server as hs
import http.client as hc
import urllib.request as ur
import shutil

PORT = 8000
REPO = 'melpa.org'
UAGENT = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1"

class UserAgentMangler(hs.BaseHTTPRequestHandler):

    def do_GET(self):
        self.handle_req('GET')

    def do_HEAD(self):
        self.handle_req('HEAD')

    def handle_req(self, req_type):
        con = None
        con_open = False
        try:
            # inits connection to REPO (e.g: elpa.gnu.org)
            con = hc.HTTPConnection(REPO)
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

            # Returns the response's headers from REPO to the caller
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

try:
    #Create a web server and define the handler to manage the
    #incoming request
    server = hs.HTTPServer(('', PORT), UserAgentMangler)

    print('Started httpserver on port ' , PORT)

    #Wait forever for incoming htto requests
    server.serve_forever()

except KeyboardInterrupt:
    print('^C received, shutting down the web server')
    server.socket.close()

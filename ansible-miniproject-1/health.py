from http.server import BaseHTTPRequestHandler, HTTPServer
import socket

DB_HOST = "10.0.10.90"
DB_PORT = 5432

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            s = socket.create_connection((DB_HOST, DB_PORT), timeout=2)
            s.close()
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"OK")
        except:
            self.send_response(500)
            self.end_headers()
            self.wfile.write(b"FAIL")

server = HTTPServer(("0.0.0.0", 80), Handler)
server.serve_forever()

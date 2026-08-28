#!/usr/bin/env python3
# 極簡 HTTP 服務，用於驗證 myapp.service 範例
import http.server, os, sys
port = int(sys.argv[sys.argv.index("--port")+1]) if "--port" in sys.argv else int(os.environ.get("PORT", "8080"))
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200); self.end_headers(); self.wfile.write(b"ok\n")
    def log_message(self, *a): pass
print(f"listening on {port}", flush=True)
http.server.HTTPServer(("127.0.0.1", port), H).serve_forever()

import http.server
import socketserver
import os

PORT = int(os.environ.get("PORT", 10000))
DIRECTORY = os.path.join(os.path.dirname(__file__), "build", "web")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        # Cabeçalhos obrigatórios para Godot 4 Web (isolamento de origem e áudio)
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cache-Control", "no-cache")
        super().end_headers()

if __name__ == "__main__":
    print(f"--- Servidor Web Onde Tudo Começou rodando na porta {PORT} ---")
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        httpd.serve_forever()

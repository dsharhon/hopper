"""
Hopper - Right Click Localhost HTTP(S) Server for Windows
TODO
*** Need ***
- Single instance DONE
- Install/Uninstall with right-click links
*** Later ***
- Host with Apache instead of Python
- Update Apache automatically
- Apache configuration with .htaccess
- HTTPS (https://gist.github.com/opyate/6e5fcabc6f41474d248613c027373856)
"""

# Boilerplate to make pythonw just work
import sys
from os import devnull
sys.stdout = open(devnull, 'w')
sys.stderr = open(devnull, 'w')

# Boilerplate to make imports just work
from os.path import dirname
from sys import path
path.append(dirname(__file__))

# Shut down existing server, if any
from http.client import HTTPConnection
from time import sleep
try:
    conn = HTTPConnection('localhost', timeout = 0.001)
    conn.request('SHUTDOWN', '/')
    conn.close()
    print('told existing server to shut down')
    # TODO: Confirm that the server has actually shut down, if ever
    sleep(0.500)
except:
    print('no existing server found')

# Change cwd (to serve) if specified
from sys import argv
if len(argv) == 2:
    from os import chdir
    print('changing directory to ' + argv[1])
    chdir(argv[1])

# Create multi-socket HTTP server with permissive CORS
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
class Handler (SimpleHTTPRequestHandler):
    def do_SHUTDOWN (self):
        print('was told to shut down')
        self.server.shutdown()
    def end_headers (self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cache-Control', 'no-store')
        SimpleHTTPRequestHandler.end_headers(self)
server = ThreadingHTTPServer(('localhost', 80), Handler)

# Locate tray icon
from os.path import join, dirname
icon = join(dirname(__file__), 'hopper.ico')

# Prepare tray tooltip
from os import getcwd
tooltip = getcwd()

# Ensure server is shutdown if tray is quit
serving = False
def on_quit(tray):
    if serving == True:
        print('shutting down server')
        server.shutdown()

# Start tray thread
from systray.traybar import SysTrayIcon
tray = SysTrayIcon(icon, tooltip, (), on_quit)
tray.start()

# Open localhost in browser
from webbrowser import open_new_tab
open_new_tab('http://localhost/')

# Run server and ensure tray is shutdown if server is quit
try:
    print('starting server')
    serving = True
    server.serve_forever()
    print('server shutdown')
except:
    print('server interrupted')
finally:
    serving = False
    tray.shutdown()

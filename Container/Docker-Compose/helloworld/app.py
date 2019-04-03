from flask import Flask
from flask import request
import urllib
import urlparse
import httplib

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello world from the container!'

@app.route('/', methods=['POST'])
def index():
    url=request.form['handler']
    host = urlparse.urlparse(url).hostname
    return urllib.urlopen(url).read()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

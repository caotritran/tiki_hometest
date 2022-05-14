import os
from flask import Flask, request, jsonify
app = Flask(__name__)

ALL_METHODS = ["GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS"]

@app.route("/", methods=ALL_METHODS)
@app.route("/<path:path>", methods=ALL_METHODS)

def handle_echo():
    if request.method == "GET":
        return jsonify({"received_headers": dict(request.headers)})
    else:
        return jsonify({"received_body": request.json, "received_headers": dict(request.headers)})
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)


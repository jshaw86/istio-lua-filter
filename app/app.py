from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def index():
    return jsonify(error_code="FOOBAR_RESPONSE", status_code=403), 403

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)



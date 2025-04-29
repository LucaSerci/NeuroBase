import json
import os
from flask import jsonify

CONFIG_PATH = "config/settings.json"

def save_config(data):
    with open("config/settings.json", "w") as f:
        json.dump(data, f, indent=2)
    return jsonify({ "message": "Config saved." })

def load_config():
    try:
        with open("config/settings.json", "r") as f:
            return json.load(f)
    except FileNotFoundError:
        return jsonify({})

import re
import sqlite3
from datetime import datetime, timezone

from flask import Flask, g, jsonify, request
from werkzeug.security import generate_password_hash

app = Flask(__name__)
DATABASE = "users.db"


def get_db():
    if "db" not in g:
        g.db = sqlite3.connect(DATABASE)
        g.db.row_factory = sqlite3.Row
        g.db.execute(
            """CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL UNIQUE,
                email TEXT NOT NULL UNIQUE,
                password_hash TEXT NOT NULL,
                created_at TEXT NOT NULL
            )"""
        )
        g.db.commit()
    return g.db


@app.teardown_appcontext
def close_db(exception):
    db = g.pop("db", None)
    if db is not None:
        db.close()


def validate_registration(data):
    errors = []

    if data is None or not isinstance(data, dict):
        return ["Request body must be a JSON object"]

    username = data.get("username")
    email = data.get("email")
    password = data.get("password")

    if not username:
        errors.append("username is required")
    elif not isinstance(username, str):
        errors.append("username must be a string")
    elif len(username) < 3 or len(username) > 30:
        errors.append("username must be between 3 and 30 characters")
    elif not re.match(r"^[a-zA-Z0-9_]+$", username):
        errors.append("username must contain only alphanumeric characters and underscores")

    if not email:
        errors.append("email is required")
    elif not isinstance(email, str):
        errors.append("email must be a string")
    elif not re.match(r"^[^@\s]+@[^@\s]+\.[^@\s]+$", email):
        errors.append("email must be a valid email address")

    if not password:
        errors.append("password is required")
    elif not isinstance(password, str):
        errors.append("password must be a string")
    elif len(password) < 8:
        errors.append("password must be at least 8 characters")
    elif not re.search(r"[A-Z]", password):
        errors.append("password must contain at least one uppercase letter")
    elif not re.search(r"[a-z]", password):
        errors.append("password must contain at least one lowercase letter")
    elif not re.search(r"[0-9]", password):
        errors.append("password must contain at least one digit")

    return errors


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"}), 200


@app.route("/register", methods=["POST"])
def register():
    data = request.get_json(silent=True)

    errors = validate_registration(data)
    if errors:
        return jsonify({"error": "Validation failed", "details": errors}), 400

    username = data["username"]
    email = data["email"].lower()
    password_hash = generate_password_hash(data["password"])
    created_at = datetime.now(timezone.utc).isoformat()

    db = get_db()
    try:
        cursor = db.execute(
            "INSERT INTO users (username, email, password_hash, created_at) VALUES (?, ?, ?, ?)",
            (username, email, password_hash, created_at),
        )
        db.commit()
    except sqlite3.IntegrityError as e:
        error_msg = str(e).lower()
        if "username" in error_msg:
            return jsonify({"error": "Username already taken"}), 409
        if "email" in error_msg:
            return jsonify({"error": "Email already registered"}), 409
        return jsonify({"error": "User already exists"}), 409

    return jsonify({
        "id": cursor.lastrowid,
        "username": username,
        "email": email,
    }), 201


if __name__ == "__main__":
    app.run(port=5001, debug=True)

import json
import random
import string
import subprocess
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

BACKEND_DIR = Path(__file__).parent / "backend"
BASE_URL = "http://127.0.0.1:8002"


def wait_for_server(timeout: float = 30.0) -> None:
    start = time.time()
    while time.time() - start < timeout:
        try:
            with urllib.request.urlopen(f"{BASE_URL}/docs", timeout=1):
                return
        except Exception:
            time.sleep(0.5)
    raise RuntimeError("Backend server did not start in time")


def request_json(method: str, path: str, data: dict | None = None, headers: dict | None = None):
    payload = None
    req_headers = headers.copy() if headers else {}
    if data is not None:
        payload = json.dumps(data).encode()
        req_headers.setdefault("Content-Type", "application/json")
    req = urllib.request.Request(
        f"{BASE_URL}{path}",
        data=payload,
        headers=req_headers,
        method=method.upper(),
    )
    with urllib.request.urlopen(req, timeout=5) as resp:
        return json.loads(resp.read().decode())


def request_form(path: str, data: dict):
    payload = urllib.parse.urlencode(data).encode()
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    req = urllib.request.Request(f"{BASE_URL}{path}", data=payload, headers=headers, method="POST")
    with urllib.request.urlopen(req, timeout=5) as resp:
        return json.loads(resp.read().decode())


def main():
    server = subprocess.Popen(
        [
            "uvicorn",
            "app.main:app",
            "--host",
            "127.0.0.1",
            "--port",
            "8002",
        ],
        cwd=BACKEND_DIR,
    )
    try:
        wait_for_server()
        username = "copilot" + ''.join(random.choices(string.ascii_lowercase + string.digits, k=6))
        password = "Test1234!"
        email = f"{username}@example.com"

        register_payload = {
            "username": username,
            "email": email,
            "password": password,
        }
        register_resp = request_json("POST", "/users/register", register_payload)

        login_resp = request_form("/users/login", {"username": username, "password": password})
        token = login_resp["access_token"]

        me_headers = {"Authorization": f"Bearer {token}"}
        me_resp = request_json("GET", "/users/me", headers=me_headers)

        result = {
            "username": username,
            "email": email,
            "register": register_resp,
            "login": login_resp,
            "me": me_resp,
        }
        print(json.dumps(result, indent=2))
    finally:
        server.terminate()
        try:
            server.wait(timeout=5)
        except subprocess.TimeoutExpired:
            server.kill()


if __name__ == "__main__":
    main()

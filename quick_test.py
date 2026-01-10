import requests
import json

url = "http://localhost:8000/users/register"
data = {
    "username": "testuser123",
    "email": "test@example.com",
    "password": "password123"
}

try:
    response = requests.post(url, json=data)
    print(f"状态码: {response.status_code}")
    print(f"响应: {response.text}")
except Exception as e:
    print(f"错误: {e}")

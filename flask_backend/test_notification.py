import requests

# Test the notifications endpoint
url = "http://localhost:5000/notifications"
params = {"user_id": "2229bccf-2991-47e8-9dfb-8b3056c4807d"}

try:
    print(f"Testing GET {url} ...")
    # We need a token normally, but let's see if it even reaches the route
    # or if it gets a 301/404/401
    response = requests.get(url, params=params)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
except Exception as e:
    print(f"Error: {e}")

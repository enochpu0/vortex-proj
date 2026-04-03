import requests
import os

url = "https://api.minimaxi.com/v1/lyrics_generation"
api_key = os.environ.get("MINIMAX_API_KEY")

payload = {
    "mode": "write_full_song",
    "prompt": "一首欢乐的新年歌曲"
}
headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {api_key}"
}

response = requests.post(url, json=payload, headers=headers)

print(response.text)

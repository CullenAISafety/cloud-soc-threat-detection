import requests
import os

SLACK_WEBHOOK = os.getenv("SLACK_WEBHOOK")

def send_alert(message):

    payload = {
        "text": message
    }

    requests.post(SLACK_WEBHOOK, json=payload)

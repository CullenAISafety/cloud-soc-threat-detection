from log_parser import parse_auth_log
from rules import detect_bruteforce
from alerting.slack_alert import send_alert

LOG_FILE = "/var/log/auth.log"

def run_detection():

    events = parse_auth_log(LOG_FILE)

    alerts = detect_bruteforce(events)

    for alert in alerts:

        message = f"""
        ALERT: SSH Brute Force Detected

        Source IP: {alert['source_ip']}
        Attempts: {alert['attempts']}
        """

        print(message)

        send_alert(message)


if __name__ == "__main__":
    run_detection()

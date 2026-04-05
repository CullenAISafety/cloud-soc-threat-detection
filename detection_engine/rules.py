def detect_bruteforce(events):

    ip_count = {}

    alerts = []

    for event in events:

        ip = event["source_ip"]

        ip_count[ip] = ip_count.get(ip, 0) + 1

        if ip_count[ip] > 10:

            alerts.append({
                "type": "SSH_BRUTE_FORCE",
                "source_ip": ip,
                "attempts": ip_count[ip]
            })

    return alerts

import re

def parse_auth_log(file_path):

    parsed_logs = []

    with open(file_path, "r") as f:
        for line in f:

            if "Failed password" in line:
                match = re.search(r"from (\d+\.\d+\.\d+\.\d+)", line)

                if match:
                    ip = match.group(1)

                    parsed_logs.append({
                        "event": "failed_login",
                        "source_ip": ip
                    })

    return parsed_logs

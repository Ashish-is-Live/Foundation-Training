def get_connection_string(file_name):
    with open(file_name) as f:
        for line in f:
            if line.startswith("url"):
                return line.strip().split("=", 1)[1]

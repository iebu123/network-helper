# Network Helper

A simple Bash script to automate network diagnostics using `ping`, `mtr`, and `traceroute`. It summarizes results and can save a detailed report to a text file.

## Features
- Checks for required tools (`ping`, `mtr`, `traceroute`).
- Runs diagnostics on a given IP address or hostname.
- Summarizes packet loss and latency.
- Optionally saves a full report with raw outputs and summary.



## Run Instantly (One-Liner)
To download and run the script directly on your server (no need to save the file):
```sh
bash <(wget -qO- https://raw.githubusercontent.com/iebu123/network-helper/main/network-helper.sh) <IP_or_hostname>
```
❗️ Note: Replace `<IP_or_hostname>` with your target IP address or domain. The script will not run without this argument.

This uses the latest version from the GitHub repository: https://github.com/iebu123/network-helper

## Usage
You can also clone or download the script and run it manually:
```sh
./network-helper.sh <IP_or_hostname>
```
Example:
```sh
./network-helper.sh 8.8.8.8
```

## Output
- Shows a summary of packet loss and latency in the terminal.
- Prompts to save a detailed report to a timestamped text file.

## Requirements
- Bash shell
- `ping`, `mtr`, and `traceroute` installed

## Example Report
```
📡 Network Diagnostics Report
Target: 8.8.8.8
Date: Sat Jun 29 2025
==================================

📶 PING Output:
----------------------------------
<full ping output>

🔍 MTR Output:
----------------------------------
<full mtr output>

🗺️ TRACEROUTE Output:
----------------------------------
<full traceroute output>

📊 Summary:
----------------------------------
Packet Loss (ping): 0%
Avg Latency (ping): 12.3 ms
Avg Loss (mtr): 0.0%
```

## License
MIT

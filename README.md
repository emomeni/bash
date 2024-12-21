# Port Scanner Script

This script is designed to check if specific ports on a given hostname or IP address are open or closed. The results are saved to a file named after the hostname.

## Usage

1. **Prompt for the hostname or IP address:**
    The script will ask you to specify the IP address or hostname you want to scan.

2. **Validate if the hostname is reachable:**
    The script will ping the hostname to ensure it is reachable. If it is not reachable, the script will exit with an error message.

3. **Prompt for the port range:**
    You will be asked to specify the range of ports you want to scan (e.g., 1-1000).

4. **Validate port range input:**
    The script will check if the provided port range is valid. If the range is invalid, the script will exit with an error message.

5. **Create a results file:**
    The script will create a file named `<hostname>.portscanner.txt` to store the results of the scan.

6. **Start port scan:**
    The script will scan the specified ports in parallel, up to 100 ports at a time.

7. **Wait for all background jobs to finish:**
    The script will wait for all port scanning jobs to complete.

8. **Display the results:**
    The script will display the results of the scan and save them to the results file.

## Example

```bash
# Run the script
./port_scanner.sh

# Example output
Please specify the IP address or hostname: example.com
Please specify the port range (e.g., 1-1000): 1-100
Starting port scan on example.com from port 1 to 100...
Results will be saved to example.com.portscanner.txt.
Port scanning completed. Results saved to example.com.portscanner.txt.
Scan results:
Port 22 is open
Port 80 is open
Port 443 is open
...
```

## Notes

- Ensure you have the necessary permissions to run the script.
- The script uses `/dev/tcp` for checking ports, which is a feature of Bash.
- The script limits to 100 parallel jobs to avoid overwhelming the system.


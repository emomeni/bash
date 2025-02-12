# Log Rotation

## Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Contributing](#contributing)

---

## Introduction
This Bash script automates the process of rotating logs on Ubuntu servers. It ensures that log files do not grow indefinitely by rotating them when they exceed a specified size limit. Old rotated logs are compressed and retained for a configurable period, after which they are deleted to save disk space.


## Features
- Multiple Log Extensions : Supports multiple file extensions (e.g., `.log`, `.txt`).
- Exclusion List : Exclude specific log files from being rotated.
- Compression : Compress old logs using `gzip` or `bzip2`.
- Email Notifications : Send email alerts when logs are rotated or if errors occur.
- Verbose Mode : Enable detailed output during execution for debugging purposes.
- Customizable Settings : Easily configure log directory, maximum size, retention count, and more.

## Installation

1. Download the script.
2. Make it executable:
   ```bash
   chmod +x logrotate.sh
   ```
3. Place the Script in a Suitable Directory :
for example, `/usr/local/bin/logrotate.sh`.

## Usage

### Running Manually
To run the script manually:
```bash
./logrotate.sh
```

### Verbose Mode
Enable verbose mode to see detailed output:
```bash
VERBOSE=true ./logrotate.sh
```

### Scheduling with Cron
To automate log rotation, schedule the script using `cron`. Edit the crontab file:
```bash
crontab -e
```

Add the following line to run the script daily at midnight:
```bash
0 0 * * * /path/to/logrotate_enhanced.sh >> /var/log/logrotate.log 2>&1
```
This will append the script's output to `/var/log/logrotate.log`.

## Contributing
If you'd like to contribute to this project, feel free to fork the repository, make changes, and submit a pull request. Suggestions for improvements are always welcome!

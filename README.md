# DNS Manager

A command-line DNS manager for Linux, providing easy and efficient DNS management functionalities.

## Features

- Add, remove, and update DNS profiles
- Set and unset DNS configurations easily
- Disable and re-enable IPv6 automatically
- Support for multiple DNS profiles

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/mvajhi/dns_manager.git
    cd dns_manager
    ```

2. Ensure the script is executable:
    ```bash
    chmod +x dns.sh
    ```

## Setup

1. Define your DNS profiles in the `.dns_profiles` file:
    ```bash
    declare -A DNS_PROFILES
    DNS_PROFILES["profile_name"]="dns1,dns2"
    ```
    Example:
    ```bash
    declare -A DNS_PROFILES
    DNS_PROFILES["403"]="10.202.10.202,10.202.10.102"
    DNS_PROFILES["shecan"]="185.51.200.2,178.22.122.100"
    ```

## Usage

### Set DNS

To set a DNS profile:
```bash
./dns.sh set DNS_NAME
```
Example:
```bash
./dns.sh set 403
```
This will set the DNS for the active connection and disable IPv6.

### Unset DNS

To unset the DNS configuration:
```bash
./dns.sh unset
```
This will re-enable automatic DNS and IPv6 for the active connection.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes.

## License

This project is licensed under the MIT License.

---
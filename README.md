IP and MAC Address Scanner with Manufacturer Lookup
This script performs a network scan to identify devices on a given IP address range and retrieves information about each device's MAC address and manufacturer. The script uses nmap for scanning, arp for retrieving MAC addresses, and a public API to look up manufacturer details based on MAC address prefixes.

Features
IP Address Class Detection: Identifies the class of the given IP address (Class A, B, or C).
Network Range Calculation: Calculates the appropriate network range to scan based on the IP class.
Fast Scanning: Uses nmap for quick network discovery with limited retries and timeout settings.
MAC Address Lookup: Retrieves the MAC addresses of active devices.
Manufacturer Identification: Looks up the manufacturer of each MAC address using a public API.
Formatted Output: Displays results in a neatly formatted table showing IP address, MAC address, and manufacturer name.
Usage
Clone the Repository:

bash
Copy code
git clone https://github.com/yourusername/your-repository.git
cd your-repository
Make the Script Executable:

bash
Copy code
chmod +x filename.sh
Run the Script:

bash
Copy code
./filename.sh
Enter the IP address when prompted.

Requirements
nmap: Network scanning tool. Install it using your package manager (e.g., apt install nmap on Debian-based systems).
curl: For making HTTP requests to the MAC address lookup API. Install it using your package manager (e.g., apt install curl).
arp: For retrieving MAC addresses from the ARP cache.
License
This project is licensed under the MIT License - see the LICENSE file for details.

Contributing
Contributions are welcome! Please fork the repository, make your changes, and submit a pull request.

Author
MD Leaul Hamd Moeen

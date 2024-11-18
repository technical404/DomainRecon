#!/bin/bash

# Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

TOOL_NAME="Domain Recon"
LINKEDIN_URL="https://www.linkedin.com/in/thepriyankrastogi"
echo -e "${GREEN}=== $(figlet -f slant "$TOOL_NAME") ===${NC}"
echo -e "${YELLOW}Created by: $LINKEDIN_URL${NC}"


function check_tools() {
    echo -e "${GREEN}Checking required tools...${NC}"
    local tools=("dig" "whois" "nmap" "openssl" "nikto" "dirb")
    for cmd in "${tools[@]}"; do
        if ! command -v $cmd >/dev/null 2>&1; then
            echo -e "${RED}Error: $cmd is not installed.${NC}"
            echo -e "${YELLOW}Please install it using your package manager and rerun the script.${NC}"
            exit 1
        fi
    done
    echo -e "${GREEN}All tools are installed.${NC}"
}


function get_dns_records() {
    local domain=$1
    echo -e "${GREEN}=== DNS Records for $domain ===${NC}"
    dig +short A $domain
    dig +short MX $domain
    dig +short NS $domain
    dig +short TXT $domain
    echo
}


function get_whois_info() {
    local domain=$1
    echo -e "${GREEN}=== WHOIS Information for $domain ===${NC}"
    whois $domain | head -n 20
    echo
}


function advanced_network_scanning() {
    local domain=$1
    echo -e "${GREEN}=== Advanced Network Scanning for $domain ===${NC}"
    nmap -A -v  $domain
    echo
}


function get_ssl_info() {
    local domain=$1
    echo -e "${GREEN}=== SSL Certificate Information for $domain ===${NC}"
    echo | openssl s_client -connect $domain:443 -servername $domain 2>/dev/null | openssl x509 -noout -text | head -n 20
    echo
}


function vulnerability_scanning() {
    local domain=$1
    echo -e "${GREEN}=== Vulnerability Scanning for $domain ===${NC}"
    echo -e "${YELLOW}Running Nikto scan...${NC}"
    nikto -h $domain
    echo
}


function content_discovery() {
    local domain=$1
    echo -e "${GREEN}=== Content Discovery for $domain ===${NC}"
    echo -e "${YELLOW}Running DIRB scan...${NC}"
    dirb http://$domain /usr/share/dirb/wordlists/common.txt -t 20
    echo
}


if [ $# -eq 0 ]; then
    echo -e "${RED}Usage: $0 <domain>${NC}"
    exit 1
fi

DOMAIN=$1


check_tools


get_dns_records $DOMAIN
get_whois_info $DOMAIN
advanced_network_scanning $DOMAIN
get_ssl_info $DOMAIN
vulnerability_scanning $DOMAIN
content_discovery $DOMAIN
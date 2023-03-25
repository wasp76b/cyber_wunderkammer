#!/bin/bash

echo "enter the domain:"
read domain

# Run the subdomain enumeration tools and save to a temporary file
subfinder -d $domain >> temp.txt
assetfinder -subs-only $domain >> temp.txt
findomain -t $domain >> temp.txt
amass enum -d $domain >> temp.txt

# Filter subdomains and remove duplicates
grep -i "$domain" temp.txt | sort -u > $domain.txt

# Extract the IPs of the subdomains and save it in a temporary file
cat $domain.txt | xargs -n1 dig +short | grep -v "^$" | sort -u > temp_ip.txt

# Save all found IPs to a text file
cat temp_ip.txt >> allsub_IP.txt

# Run httpx on subdomains and save to a file
httpx -l $domain.txt -silent -threads 1000 | sort -u > "200http_$domain.txt"

# Run httpx on the IPs and save to a file
httpx -l allsub_IP.txt -silent -threads 1000 | sort -u > "200http_ip.txt"

# Remove temporary files
rm temp.txt
rm temp_ip.txt

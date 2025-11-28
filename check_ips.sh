check_ips() 
{
  file="$1"

  if [ ! -f "$file" ]; then
    echo "Error: file not found"
    return 1
  fi

  # Clear or create the output file
  > alive_hosts.txt

  # Extract unique IPv4 addresses
  ips=$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$file" | sort -u)

  for ip in $ips; do
    if ping -c1 -W1 "$ip" &>/dev/null; then
      echo "[+] $ip alive"
      echo "$ip" >> alive_hosts.txt
    fi
  done
}
ping_sweep() {
  subnet="$1"
  if [ -z "$subnet" ]; then
    echo "Usage: ping_sweep <subnet_prefix>"
    echo "Example: ping_sweep 10.0.0"
    return 1
  fi

  for i in {1..10}; do
    ip="$subnet.$i"
    (ping -c1 -W1 "$ip" &>/dev/null && echo "[+] $ip alive") &
  done
  wait
}

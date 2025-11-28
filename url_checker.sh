#!/bin/bash
infile=${1:-urls.txt}
while IFS= read -r url; do
  [ -z "$url" ] && continue
  code=$(curl -o /dev/null -s -w "%{http_code}" "$url")
  if [ "$code" = "200" ]; then
    echo "[OK] $url"
  else
    echo "[FAIL $code] $url"
  fi
done < "$infile"
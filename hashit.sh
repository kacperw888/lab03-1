hashit() {
  algo=${1:-sha256}
  shift
  if [ -z "$algo" ]; then
    echo "Usage: hashit <algo> <string_or_file> or pipe data"
    return 1
  fi
  if [ ! -t 0 ]; then
    # piped data
    python3 - "$algo" <<'PY'
import sys, hashlib
algo = sys.argv[1]
data = sys.stdin.buffer.read()
try:
    h = hashlib.new(algo)
except (ValueError, TypeError):
    sys.stderr.write(f"Algorithm not supported: {algo}\n")
    sys.exit(2)
h.update(data)
sys.stdout.write(h.hexdigest())
PY
    return
  fi
  for t in "$@"; do
    if [ -f "$t" ]; then
      python3 - "$algo" "$t" <<'PY'
import sys, hashlib
algo = sys.argv[1]
path = sys.argv[2]
try:
    h = hashlib.new(algo)
except (ValueError, TypeError):
    sys.stderr.write(f"Algorithm not supported: {algo}\n")
    sys.exit(2)
with open(path, 'rb') as f:
    for chunk in iter(lambda: f.read(8192), b''):
        h.update(chunk)
sys.stdout.write(h.hexdigest())
PY
    else
      python3 - "$algo" "$t" <<'PY'
import sys, hashlib
algo = sys.argv[1]
s = sys.argv[2].encode()
try:
    h = hashlib.new(algo)
except (ValueError, TypeError):
    sys.stderr.write(f"Algorithm not supported: {algo}\n")
    sys.exit(2)
h.update(s)
sys.stdout.write(h.hexdigest())
PY
    fi
  done
}
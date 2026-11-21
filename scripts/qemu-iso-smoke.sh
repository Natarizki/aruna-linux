#!/usr/bin/env bash
set -euo pipefail

ISO="${1:?Usage: qemu-iso-smoke.sh <installer.iso> [output-dir]}"
OUT="${2:-qemu-smoke}"
DURATION="${QEMU_TEST_SECONDS:-90}"
mkdir -p "$OUT"

CODE="$(find /usr/share/OVMF /usr/share/ovmf -type f \\( -iname 'OVMF_CODE*.fd' -o -iname 'OVMF_CODE*.bin' \\) 2>/dev/null | sort | head -n1 || true)"
if [[ -z "$CODE" ]]; then
  echo "ERROR: No x86_64 OVMF firmware image found." | tee "$OUT/summary.txt"
  exit 1
fi

VARS="$(find /usr/share/OVMF /usr/share/ovmf -type f \\( -iname 'OVMF_VARS*.fd' -o -iname 'OVMF_VARS*.bin' \\) 2>/dev/null | sort | head -n1 || true)"
if [[ -z "$VARS" ]]; then
  echo "ERROR: No OVMF variable-store template found." | tee "$OUT/summary.txt"
  exit 1
fi

cp "$VARS" "$OUT/OVMF_VARS.fd"
SOCK="$OUT/qemu-monitor.sock"
rm -f "$SOCK"

echo "Starting QEMU x86_64 UEFI ISO smoke run for ${DURATION}s..."
qemu-system-x86_64 \
  -machine q35,accel=tcg \
  -cpu max \
  -m 4096 \
  -smp 2 \
  -drive if=pflash,format=raw,readonly=on,file="$CODE" \
  -drive if=pflash,format=raw,file="$OUT/OVMF_VARS.fd" \
  -drive file="$ISO",media=cdrom,readonly=on \
  -boot order=d \
  -display none \
  -serial "file:$OUT/serial.log" \
  -monitor "unix:$SOCK,server,nowait" \
  -no-reboot -no-shutdown \
  -D "$OUT/qemu-debug.log" \
  -d guest_errors \
  >"$OUT/qemu-console.log" 2>&1 &
QEMU_PID=$!

cleanup() {
  kill "$QEMU_PID" 2>/dev/null || true
  wait "$QEMU_PID" 2>/dev/null || true
}
trap cleanup EXIT

sleep 8
if ! kill -0 "$QEMU_PID" 2>/dev/null; then
  echo "ERROR: QEMU exited before the test interval." | tee "$OUT/summary.txt"
  cat "$OUT/qemu-console.log"
  exit 1
fi

sleep "$((DURATION - 8))"

python3 - "$SOCK" "$OUT/boot-screen.ppm" <<'PY'
import socket, sys, time
sock_path, screenshot = sys.argv[1:3]
deadline = time.time() + 20
s = None
while time.time() < deadline:
    try:
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(sock_path)
        break
    except OSError:
        if s:
            s.close()
        s = None
        time.sleep(1)
if s is None:
    raise SystemExit("Could not connect to QEMU monitor")
s.settimeout(3)
try:
    s.recv(4096)
except OSError:
    pass
s.sendall(f"screendump {screenshot}\\n".encode())
time.sleep(2)
try:
    response = s.recv(4096).decode(errors="replace")
    print(response)
finally:
    s.close()
PY

test -s "$OUT/boot-screen.ppm"
cat > "$OUT/summary.txt" <<EOF
QEMU x86_64 UEFI smoke run: PASS
Firmware: OVMF x86_64
Virtual machine: QEMU TCG, q35, 4 GiB RAM, 2 vCPUs
ISO: $(basename "$ISO")
Run duration: ${DURATION}s
Screenshot: boot-screen.ppm

IMPORTANT: PASS means QEMU stayed running for the test interval and produced a VGA screenshot.
It does not prove that the live OS fully booted or that IA32 UEFI / Bay Trail mixed-mode boot works.
EOF
cat "$OUT/summary.txt"

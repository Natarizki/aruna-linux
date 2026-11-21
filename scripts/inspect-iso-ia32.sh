#!/usr/bin/env bash
set -euo pipefail

ISO="${1:?Usage: inspect-iso-ia32.sh <installer.iso>}"
OUT="${2:-ia32-audit}"
mkdir -p "$OUT"

echo "== ISO metadata =="
file "$ISO" | tee "$OUT/iso-file.txt"
sha256sum "$ISO" | tee "$OUT/iso-sha256.txt"

echo "== El Torito boot catalog =="
xorriso -indev "$ISO" -report_el_torito as_mkisofs -end 2>&1 | tee "$OUT/el-torito.txt"

echo "== Extract embedded boot images =="
mkdir -p "$OUT/boot-images"
xorriso -osirrox on -indev "$ISO" -extract_boot_images "$OUT/boot-images" 2>&1 | tee "$OUT/extract-boot-images.txt"

echo "== Inspect EFI files inside embedded FAT boot images =="
while IFS= read -r -d '' img; do
  echo "-- $img --"
  mdir -i "$img" -s :: 2>&1 || true
done < <(find "$OUT/boot-images" -type f -print0) | tee "$OUT/fat-image-inventory.txt"

echo "== Inspect ISO EFI directory =="
mkdir -p "$OUT/iso-efi"
xorriso -osirrox on -indev "$ISO" -extract /EFI "$OUT/iso-efi/EFI" 2>&1 | tee "$OUT/extract-efi.txt" || true

{
  echo "EFI files found in extracted boot images and ISO tree:"
  find "$OUT/boot-images" "$OUT/iso-efi" -type f -print 2>/dev/null | sort || true
  cat "$OUT/fat-image-inventory.txt" 2>/dev/null || true
  echo
  echo "EFI executable formats:"
  find "$OUT/boot-images" "$OUT/iso-efi" -type f -print0 2>/dev/null |
    while IFS= read -r -d '' f; do file "$f"; done || true
} | tee "$OUT/efi-inventory.txt"

if grep -Eiq 'BOOTIA32\.EFI|gcdia32\.efi|grubia32\.efi' "$OUT/efi-inventory.txt"; then
  echo "IA32 EFI binary detected. This is presence-only, not a boot test." | tee "$OUT/ia32-result.txt"
else
  echo "No recognizable IA32 EFI bootloader found in the ISO boot images or EFI tree." | tee "$OUT/ia32-result.txt"
fi

if grep -Eiq 'BOOTX64\.EFI|shimx64\.efi|gcdx64\.efi|grubx64\.efi' "$OUT/efi-inventory.txt"; then
  echo "x86_64 EFI bootloader detected." | tee -a "$OUT/ia32-result.txt"
else
  echo "WARNING: no recognizable x86_64 EFI bootloader name detected." | tee -a "$OUT/ia32-result.txt"
fi

echo "Audit complete. IA32 firmware compatibility and kernel mixed-mode support are NOT established by this inventory." | tee -a "$OUT/ia32-result.txt"

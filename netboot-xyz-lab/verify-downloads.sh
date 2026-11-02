#!/bin/sh
# Verify downloaded netboot.xyz release files against the
# published checksums file. Usage, in the folder holding both
# the downloads and netboot.xyz-sha256-checksums.txt:
#
#   sh verify-downloads.sh FILE [FILE...]
#
# Prints sha256sum's verdict per file; "OK" is the only
# acceptable answer. Used in transcript t02.
set -eu
grep -E "$(printf '%s' "$*" | tr ' ' '|')" \
  netboot.xyz-sha256-checksums.txt > lab-checksums.txt
sha256sum -c lab-checksums.txt

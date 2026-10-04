#!/bin/bash
# Build a Barron's EPUB on this Mac and email it to the Kindle.
#
# Usage:
#   ./send-to-kindle.sh latest     # newest articles
#   ./send-to-kindle.sh magazine   # this week's magazine
#
# One-time setup: create ~/.barrons-kindle.env containing
#   GMAIL_USER="you@gmail.com"
#   GMAIL_APP_PASSWORD="abcdefghijklmnop"
#   KINDLE_EMAIL="name@kindle.com"
# then: chmod 600 ~/.barrons-kindle.env

set -euo pipefail

MODE="${1:-latest}"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CALIBRE_BIN="/Applications/calibre.app/Contents/MacOS"
ENV_FILE="$HOME/.barrons-kindle.env"
OUT_DIR="$HOME/Documents/Barrons"

NEEDS_COOKIES=yes
CHECK_FULLTEXT=yes
case "$MODE" in
  latest)   RECIPE="$REPO_DIR/barrons-latest-full.recipe"; NAME="Barrons-Latest" ;;
  magazine) RECIPE="$REPO_DIR/barrons-full.recipe";        NAME="Barrons-Magazine" ;;
  briefing) RECIPE="$REPO_DIR/markets-briefing.recipe";    NAME="Markets-Briefing"; NEEDS_COOKIES=no ;;
  reuters)  RECIPE="Reuters.recipe";                       NAME="Reuters"; NEEDS_COOKIES=no; CHECK_FULLTEXT=no ;;
  *) echo "Usage: $0 latest|magazine|briefing|reuters"; exit 1 ;;
esac

[ -f "$ENV_FILE" ] || { echo "Missing $ENV_FILE (see top of this script)"; exit 1; }
source "$ENV_FILE"
if [ "$NEEDS_COOKIES" = yes ] && [ ! -f "$HOME/barrons-cookies.txt" ]; then
  echo "Missing ~/barrons-cookies.txt - export cookies from Chrome first"; exit 1
fi

mkdir -p "$OUT_DIR"
STAMP="$(date +%Y-%m-%d_%H%M)"
EPUB="$OUT_DIR/${NAME}_${STAMP}.epub"
LOG="$OUT_DIR/${NAME}_${STAMP}.log"

echo "Building $MODE edition (takes a few minutes)..."
"$CALIBRE_BIN/ebook-convert" "$RECIPE" "$EPUB" \
  --output-profile kindle_oasis > "$LOG" 2>&1 || {
    echo "Build failed. Last lines of log:"; tail -20 "$LOG"; exit 1; }

if [ "$CHECK_FULLTEXT" = yes ]; then
  RESULT="$(grep 'Articles with full text' "$LOG" | tail -1 || true)"
  echo "$RESULT"
  FULL="$(echo "$RESULT" | sed -n 's/.*full text: \([0-9]*\).*/\1/p')"
  if [ -z "$FULL" ] || [ "$FULL" -eq 0 ]; then
    if [ "$NEEDS_COOKIES" = yes ]; then
      echo "No full-text articles - cookies have probably expired."
      echo "Re-export them from Chrome to ~/barrons-cookies.txt and try again. Not sending."
    else
      echo "No full-text articles - the site layout may have changed. Log: $LOG. Not sending."
    fi
    exit 1
  fi
fi

echo "Emailing to $KINDLE_EMAIL..."
"$CALIBRE_BIN/calibre-smtp" \
  --attachment "$EPUB" \
  --subject "$NAME $STAMP" \
  --relay smtp.gmail.com --port 587 --encryption-method TLS \
  --username "$GMAIL_USER" --password "$GMAIL_APP_PASSWORD" \
  "$GMAIL_USER" "$KINDLE_EMAIL" "Barron's $MODE edition"

echo "Sent: $EPUB"

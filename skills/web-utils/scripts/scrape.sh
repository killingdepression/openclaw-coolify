#!/bin/bash

# Default Mode
MODE="curl"
URL=""
ANYCRAWL_URL="${ANYCRAWL_API_URL:-http://anycrawldocker:13939}"

# Parse Args
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --mode) MODE="$2"; shift ;;
        *) URL="$1" ;;
    esac
    shift
done

if [ -z "$URL" ]; then
    echo "Usage: $0 [--mode curl|browser|anycrawl] <url>"
    exit 1
fi

echo "🕷️ Scraping ($MODE): $URL" >&2

if [ "$MODE" == "curl" ]; then
    curl -sL \
        -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
        "$URL"

elif [ "$MODE" == "anycrawl" ]; then
    # Use AnyCrawl Service
    # Based on user snippet: curl "http://localhost:13939?url=..."
    # We use the internal service URL
    echo "Calling AnyCrawl at $ANYCRAWL_URL..." >&2
    ENCODED_URL=$(echo "$URL" | jq -sRr @uri)
    curl -s "${ANYCRAWL_URL}/?url=${ENCODED_URL}"

elif [ "$MODE" == "browser" ]; then
    # Use Botasaurus Python Script
    SCRIPT_DIR="$(dirname "$0")"
    python3 "$SCRIPT_DIR/scrape_botasaurus.py" "$URL"

else
    echo "Unknown mode: $MODE"
    exit 1
fi

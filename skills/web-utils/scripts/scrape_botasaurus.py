from botasaurus.request import request, Request
import sys
import json

# Minimal Botasaurus scraper
# Usage: python3 scrape_botasaurus.py <url>

@request
def scrape(request: Request, data):
    # Retrieve URL from data
    url = data
    response = request.get(url)
    # Return HTML or Text
    return {
        "url": url,
        "status": response.status_code,
        "title": response.soup.title.string if response.soup.title else "",
        "text": response.text,  # Or response.soup.get_text() for cleaner text
        "html": response.content # HTML Content
    }

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No URL provided"}))
        sys.exit(1)

    url = sys.argv[1]
    
    try:
        # Run the scraper
        result = scrape(url)
        print(json.dumps(result, default=str)) # Botasaurus returns result directly
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)

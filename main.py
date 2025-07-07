from fastapi import FastAPI
from playwright.sync_api import sync_playwright
import json

app = FastAPI()

@app.get("/")
def root():
    return {"status": "ok"}

@app.post("/download-matches")
def download_matches():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context()

        # ✅ Load cookies instead of login
        with open("cookies.json", "r") as f:
            cookies = json.load(f)
        context.add_cookies(cookies)

        page = context.new_page()

        # Download today
        page.goto("https://footystats.org/")
        page.wait_for_selector('a[href*="matches_expanded"]')
        url_today = page.get_attribute('a[href*="matches_expanded"]', 'href')
        csv_today = page.request.get("https://footystats.org" + url_today)
        with open("matches_today.csv", "wb") as f:
            f.write(csv_today.body())

        # Download tomorrow
        page.goto("https://footystats.org/tomorrow/")
        page.wait_for_selector('a[href*="matches_expanded"]')
        url_tomorrow = page.get_attribute('a[href*="matches_expanded"]', 'href')
        csv_tomorrow = page.request.get("https://footystats.org" + url_tomorrow)
        with open("matches_tomorrow.csv", "wb") as f:
            f.write(csv_tomorrow.body())

        browser.close()
    return {"status": "downloaded"}

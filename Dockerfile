FROM python:3.10-slim

WORKDIR /app

# Install system dependencies required by Playwright
RUN apt-get update && apt-get install -y \
    wget gnupg curl ca-certificates fonts-liberation libnss3 libatk1.0-0 \
    libatk-bridge2.0-0 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 \
    libxkbcommon0 libxext6 libxfixes3 libgbm1 libasound2 libx11-6 libxss1 \
    libxcursor1 libxi6 libnss3 libnspr4 libdbus-1-3 libdrm2 libxshmfence1 \
    && apt-get clean

# Install Node.js and Playwright
RUN wget -qO- https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs \
 && npm i -g playwright \
 && playwright install chromium

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

FROM python:3.10-slim

WORKDIR /app

# Install system dependencies and Playwright
RUN apt-get update && apt-get install -y wget gnupg curl \
 && wget -qO- https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs \
 && npm i -g playwright && playwright install chromium

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

# Force rebuild

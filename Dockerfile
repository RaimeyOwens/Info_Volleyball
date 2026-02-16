FROM node:20-slim

# Install system dependencies and Chromium
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       wget \
       gnupg \
       python3 \
       python3-pip \
       fonts-liberation \
       libatk1.0-0 \
       libatk-bridge2.0-0 \
       libcups2 \
       libxcomposite1 \
       libxdamage1 \
       libxrandr2 \
       libxss1 \
       libgtk-3-0 \
       libasound2 \
       libgbm1 \
       libnss3 \
       libx11-6 \
       libx11-xcb1 \
       libpango-1.0-0 \
       libxshmfence1 \
    && rm -rf /var/lib/apt/lists/*

# Install Chromium
RUN apt-get update && apt-get install -y --no-install-recommends chromium || true && rm -rf /var/lib/apt/lists/*

# Install Lighthouse
RUN npm install -g lighthouse

WORKDIR /app
COPY . /app

EXPOSE 4356

# Start a simple HTTP server and run Lighthouse against it, saving report to /app
CMD python3 -m http.server 4356 & \
    CHROME_PATH=$(which chromium || which chromium-browser || echo /usr/bin/chromium) npx -y lighthouse "http://localhost:4356" --output html --output-path ./lighthouse-report.html --chrome-flags="--headless --no-sandbox"

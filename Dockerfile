FROM node:20-alpine

# Install dependencies + curl for solc download
RUN apk add --no-cache git python3 make g++ curl

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Copy project files
COPY . .

# Pre-download solc compiler (Hardhat uses ~/.solc-select or cache)
RUN mkdir -p cache/hardhat/solc/0.8.19-soljson && \
    cd cache/hardhat/solc/0.8.19-soljson && \
    curl -L https://github.com/ethereum/solc-bin/raw/gh-pages/bin/linux-amd64/solc-linux \
         -o solc-linux && \
    chmod +x solc-linux || true

# Compile contracts (will use local if available, else downloads)
RUN npx hardhat compile

CMD ["npx", "hardhat", "test"]

# Extend the mcp-proxy image
FROM ghcr.io/sparfenyuk/mcp-proxy:latest

# Install dependencies needed for uv and git
USER root
RUN apk add --no-cache \
    curl \
    git \
    ca-certificates \
    bash

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Clone the mealie-mcp-server repository
WORKDIR /app
RUN git clone https://github.com/rldiao/mealie-mcp-server.git

# Install Python dependencies using uv
WORKDIR /app/mealie-mcp-server
RUN uv sync

# Set the working directory for runtime
WORKDIR /app/mealie-mcp-server

# The entrypoint will use mcp-proxy to run the server
ENTRYPOINT ["mcp-proxy", "--sse-port", "9000", "--"]
CMD ["uv", "run", "python", "src/server.py"]

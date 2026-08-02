FROM python:3.12-slim

# Install curl (needed to install uv)
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

# Copy dependency files first for better layer caching
COPY pyproject.toml uv.lock .python-version ./

# Install dependencies from the lock file
RUN uv sync

# Copy the rest of the project
COPY . .

# Run the application
CMD ["uv", "run", "python", "main.py"]
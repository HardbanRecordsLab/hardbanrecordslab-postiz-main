# Hugging Face Spaces Dockerfile for Postiz
# Requires: 16GB RAM (HF PRO tier)
# Port: 7860 (HF requirement)

FROM node:22.12.0-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    libudev-dev \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Enable pnpm with specific version
RUN corepack enable && corepack prepare pnpm@10.6.1 --activate

WORKDIR /app

# Environment variables (will be overridden by HF Secrets)
ENV NODE_ENV=production
ENV PORT=4200
ENV BACKEND_PORT=3000

# Copy package files for dependency installation
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/backend/package.json ./apps/backend/
COPY apps/frontend/package.json ./apps/frontend/
COPY apps/orchestrator/package.json ./apps/orchestrator/
COPY apps/commands/package.json ./apps/commands/
COPY apps/extension/package.json ./apps/extension/
COPY apps/sdk/package.json ./apps/sdk/

# Copy library package files
COPY libraries/nestjs-libraries/package.json ./libraries/nestjs-libraries/ 2>/dev/null || true
COPY libraries/react-shared-libraries/package.json ./libraries/react-shared-libraries/ 2>/dev/null || true
COPY libraries/helpers/package.json ./libraries/helpers/ 2>/dev/null || true

# Install dependencies
RUN pnpm install --frozen-lockfile --prod=false

# Copy source code
COPY . .

# Generate Prisma Client
RUN pnpm run prisma-generate

# Build all apps
RUN pnpm run build:backend && \
    pnpm run build:frontend && \
    pnpm run build:orchestrator

# Clean up dev dependencies to reduce image size
RUN pnpm prune --prod

# Expose HF required port
EXPOSE 7860

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:7860/ || exit 1

# Start script
COPY start-hf.sh ./
RUN chmod +x start-hf.sh

CMD ["./start-hf.sh"]

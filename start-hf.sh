#!/bin/bash
set -e

echo "============================================"
echo "🚀 Starting Postiz on Hugging Face Spaces"
echo "============================================"

# Check required environment variables
if [ -z "$DATABASE_URL" ]; then
    echo "❌ ERROR: DATABASE_URL is not set"
    exit 1
fi

if [ -z "$REDIS_URL" ]; then
    echo "❌ ERROR: REDIS_URL is not set"
    exit 1
fi

if [ -z "$JWT_SECRET" ]; then
    echo "❌ ERROR: JWT_SECRET is not set"
    exit 1
fi

echo "✅ Environment variables validated"

# Wait for external database
echo "⏳ Waiting for PostgreSQL database..."
max_attempts=30
attempt=0

# Extract host from DATABASE_URL
DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*@\([^:\/]*\).*/\1/p')

while ! pg_isready -h "$DB_HOST" > /dev/null 2>&1; do
    attempt=$((attempt+1))
    if [ $attempt -eq $max_attempts ]; then
        echo "❌ Database not available after $max_attempts attempts"
        exit 1
    fi
    echo "  Attempt $attempt/$max_attempts..."
    sleep 2
done

echo "✅ Database is ready"

# Push Prisma schema to database
echo "📊 Initializing database schema..."
pnpm run prisma-db-push || {
    echo "⚠️  Prisma push failed, trying to continue..."
}

echo "✅ Database schema initialized"

# Create log directory
mkdir -p /tmp/logs

# Start Backend (NestJS on port 3000)
echo "🔧 Starting Backend API..."
pnpm run start:prod:backend > /tmp/logs/backend.log 2>&1 &
BACKEND_PID=$!
echo "  Backend PID: $BACKEND_PID"

# Wait for backend to be ready
echo "⏳ Waiting for backend to start..."
sleep 10

# Start Frontend (Next.js on port 4200)
echo "🎨 Starting Frontend..."
pnpm run start:prod:frontend > /tmp/logs/frontend.log 2>&1 &
FRONTEND_PID=$!
echo "  Frontend PID: $FRONTEND_PID"

# Wait for frontend to be ready
echo "⏳ Waiting for frontend to start..."
sleep 15

# Start Orchestrator (Temporal workflows)
if [ ! -z "$TEMPORAL_ADDRESS" ]; then
    echo "⚡ Starting Orchestrator..."
    pnpm run start:prod:orchestrator > /tmp/logs/orchestrator.log 2>&1 &
    ORCHESTRATOR_PID=$!
    echo "  Orchestrator PID: $ORCHESTRATOR_PID"
else
    echo "⚠️  TEMPORAL_ADDRESS not set, skipping orchestrator"
fi

# Create reverse proxy on port 7860 (HF requirement)
echo "💚 Starting reverse proxy on port 7860..."

cat > /tmp/proxy.js << 'PROXYEOF'
const http = require('http');

const FRONTEND_PORT = 4200;
const PROXY_PORT = 7860;

const server = http.createServer((req, res) => {
  const options = {
    hostname: 'localhost',
    port: FRONTEND_PORT,
    path: req.url,
    method: req.method,
    headers: req.headers
  };

  const proxy = http.request(options, (proxyRes) => {
    res.writeHead(proxyRes.statusCode, proxyRes.headers);
    proxyRes.pipe(res);
  });

  proxy.on('error', (err) => {
    console.error('Proxy error:', err);
    res.writeHead(502, { 'Content-Type': 'text/plain' });
    res.end('Bad Gateway - Frontend not available');
  });

  req.pipe(proxy);
});

server.on('error', (err) => {
  console.error('Server error:', err);
  process.exit(1);
});

server.listen(PROXY_PORT, '0.0.0.0', () => {
  console.log(`✅ Postiz is ready on http://0.0.0.0:${PROXY_PORT}`);
  console.log(`📊 Frontend: http://localhost:${FRONTEND_PORT}`);
  console.log(`🔧 Backend: http://localhost:3000`);
  console.log('============================================');
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('Received SIGTERM, shutting down gracefully...');
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});
PROXYEOF

# Start the proxy (this will keep the container running)
node /tmp/proxy.js

# If proxy exits, show logs for debugging
echo "❌ Proxy stopped unexpectedly"
echo "Backend logs:"
tail -n 50 /tmp/logs/backend.log
echo "Frontend logs:"
tail -n 50 /tmp/logs/frontend.log
exit 1

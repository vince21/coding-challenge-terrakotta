#!/bin/bash

echo "🚀 Starting Address Normalizer Challenge..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is required but not installed${NC}"
    exit 1
fi

# Check if Node is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is required but not installed${NC}"
    exit 1
fi

# Kill any existing processes on our ports
echo "📋 Cleaning up any existing processes..."
lsof -ti:8001 | xargs kill -9 2>/dev/null
lsof -ti:5173 | xargs kill -9 2>/dev/null

# Start backend
echo -e "${BLUE}🔧 Starting backend server...${NC}"
cd server
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

source venv/bin/activate 2>/dev/null || . venv/Scripts/activate 2>/dev/null || {
    echo -e "${RED}❌ Failed to activate virtual environment${NC}"
    exit 1
}

pip install -q -r requirements.txt
python app.py &
BACKEND_PID=$!
cd ..

# Wait for backend to start
echo "Waiting for backend to start..."
sleep 3

# Start frontend
echo -e "${BLUE}🎨 Starting frontend...${NC}"
cd client
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install --silent
fi
npm run dev &
FRONTEND_PID=$!
cd ..

# Give frontend a moment to start
sleep 3

echo ""
echo -e "${GREEN}✅ Challenge is ready!${NC}"
echo ""
echo "📍 Frontend: http://localhost:5173"
echo "📍 Backend:  http://localhost:8001"
echo ""
echo "📖 Instructions:"
echo "1. Fix the prompt in server/prompting.py"
echo "2. Complete the models in server/models.py"
echo "3. Wire up the frontend to display results nicely"
echo ""
echo "Press Ctrl+C to stop all servers"
echo ""

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "Shutting down servers..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    lsof -ti:8001 | xargs kill -9 2>/dev/null
    lsof -ti:5173 | xargs kill -9 2>/dev/null
    echo "✅ Cleanup complete"
    exit 0
}

# Set up trap to cleanup on Ctrl+C
trap cleanup INT

# Keep script running
while true; do
    sleep 1
done
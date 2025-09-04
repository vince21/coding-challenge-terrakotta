#!/bin/bash

echo "🧪 Running Automated Tests..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCORE=0
MAX_SCORE=100

# Start servers
echo "Starting servers..."
cd server
source venv/bin/activate 2>/dev/null || python3 -m venv venv && source venv/bin/activate
pip install -q -r requirements.txt
python app.py &
BACKEND_PID=$!
cd ..
sleep 3

# Test 1: Backend health check
echo -n "Testing backend health endpoint... "
if curl -s http://localhost:8001/health | grep -q "healthy"; then
    echo -e "${GREEN}✓${NC} (+10 points)"
    ((SCORE+=10))
else
    echo -e "${RED}✗${NC}"
fi

# Test 2: Basic normalization
echo -n "Testing basic normalization... "
RESPONSE=$(curl -s -X POST http://localhost:8001/normalize \
    -H "Content-Type: application/json" \
    -d '{"name": "John Smith", "address": "123 Main St, Seattle, WA 98101"}')

if echo "$RESPONSE" | grep -q "person"; then
    echo -e "${GREEN}✓${NC} (+20 points)"
    ((SCORE+=20))
else
    echo -e "${RED}✗${NC}"
fi

# Test 3: Complex name handling
echo -n "Testing complex names (Dr., Jr., etc)... "
RESPONSE=$(curl -s -X POST http://localhost:8001/normalize \
    -H "Content-Type: application/json" \
    -d '{"name": "Dr. James O'"'"'Brien Jr.", "address": "PO Box 789, Boston, MA 02101"}')

if echo "$RESPONSE" | grep -q "family_name"; then
    echo -e "${GREEN}✓${NC} (+15 points)"
    ((SCORE+=15))
else
    echo -e "${YELLOW}Partial${NC} (+5 points)"
    ((SCORE+=5))
fi

# Test 4: Apartment handling
echo -n "Testing apartment/unit parsing... "
RESPONSE=$(curl -s -X POST http://localhost:8001/normalize \
    -H "Content-Type: application/json" \
    -d '{"name": "Jane Doe", "address": "456 Oak Ave Apt 3B, San Francisco, CA 94102"}')

if echo "$RESPONSE" | grep -q "address"; then
    echo -e "${GREEN}✓${NC} (+15 points)"
    ((SCORE+=15))
else
    echo -e "${YELLOW}Partial${NC} (+5 points)"
    ((SCORE+=5))
fi

# Test 5: Check for confidence scores
echo -n "Testing confidence scores... "
if echo "$RESPONSE" | grep -q "confidence"; then
    echo -e "${GREEN}✓${NC} (+10 points)"
    ((SCORE+=10))
else
    echo -e "${RED}✗${NC}"
fi

# Test 6: Frontend accessibility
echo -n "Testing frontend is running... "
if curl -s http://localhost:5173 | grep -q "Address Normalizer"; then
    echo -e "${GREEN}✓${NC} (+10 points)"
    ((SCORE+=10))
else
    echo -e "${RED}✗${NC}"
fi

# Cleanup
kill $BACKEND_PID 2>/dev/null
lsof -ti:8001 | xargs kill -9 2>/dev/null
lsof -ti:5173 | xargs kill -9 2>/dev/null

echo ""
echo "=============================="
echo -e "Final Score: ${GREEN}${SCORE}/${MAX_SCORE}${NC}"
echo "=============================="
echo ""

if [ $SCORE -ge 80 ]; then
    echo -e "${GREEN}🎉 Excellent work!${NC}"
elif [ $SCORE -ge 60 ]; then
    echo -e "${YELLOW}👍 Good job, some improvements needed${NC}"
else
    echo -e "${RED}📚 Needs more work on the core requirements${NC}"
fi

exit 0
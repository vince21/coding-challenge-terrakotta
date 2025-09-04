# Address Normalizer Challenge

**Time Limit:** 30 minutes  
**Difficulty:** Senior SWE

## 🎯 Your Task

Build a system that takes messy, real-world address data and normalizes it using OpenAI's **structured outputs** feature. You'll need to:

1. **Implement Pydantic models** for structured output in `server/prompting.py`
2. **Use OpenAI's response_format** to get reliable JSON output
3. **Complete the TODO sections** in models and backend
4. **Wire up the frontend** to display results nicely

## 🚀 Quick Start (2 minutes)

```bash
# One command to start everything:
./start.sh

# Or manually:
cd server && python app.py &
cd client && npm install && npm run dev
```

Then open http://localhost:5173

## 📋 Requirements

### Core Tasks (Must Complete)
- [ ] Fix the GPT prompt to reliably parse addresses into structured format
- [ ] Complete the Pydantic models in `server/models.py`
- [ ] Handle edge cases (apartments, PO boxes, international addresses)
- [ ] Display the normalized data cleanly in the UI

### Bonus Points
- [ ] Add input validation
- [ ] Show confidence scores
- [ ] Handle errors gracefully
- [ ] Add tests for edge cases

## 🧪 Test Cases to Handle

Your solution should handle these inputs correctly:

```
Easy:
- "John Smith", "123 Main St, Seattle, WA 98101"

Medium:
- "María García-López", "456 Oak Ave Apt 3B, San Francisco, CA"
- "Dr. James O'Brien Jr.", "PO Box 789, New York, NY 10001"

Hard:
- "李明 (Li Ming)", "1-2-3 Shibuya, Tokyo, Japan 150-0002"
- "Jean-Baptiste de la Fontaine", "15 Rue de la Paix, 75002 Paris, France"
```

## 💡 Hints

1. **Structured Outputs:** Use `response_format=YourModel` in OpenAI's API for guaranteed structure
2. **Pydantic Models:** Define models that match your exact needs - OpenAI will follow them
3. **System Prompt:** Even with structured output, a good system prompt helps accuracy
4. **Validation:** Pydantic validates automatically with structured outputs
5. **Example:** Check OpenAI docs for `client.chat.completions.parse()` usage

## 📊 Evaluation Criteria

- **Works End-to-End (30%):** Form submission → API → Display
- **Structured Output Implementation (40%):** Proper Pydantic models, uses response_format correctly
- **Code Quality (20%):** Clean, readable, proper error handling
- **Bonus Features (10%):** Confidence scores, validation, tests, UX improvements

## 🔧 Tech Stack

- Backend: Python/Flask + OpenAI API (mocked for testing)
- Frontend: React + TypeScript + Vite
- Models: Pydantic for validation

## 📝 Submission

When done, run `./test.sh` to verify your solution works with our test cases.

Good luck! 🚀
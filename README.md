# Address Normalizer Challenge

- <span style="color:red">**Problem:**</span> Terrakotta customers often enter messy, unstructured address data into the platform.
- <span style="color:green">**Goal:**</span> Build a system that takes messy, real-world address data and normalizes / structures it using OpenAI's **structured outputs** feature ([see docs](https://platform.openai.com/docs/guides/structured-outputs)).

## 1. **Design Your Data Models**
- <span style="color:green">**Start Here:**</span> create Pydantic models in `server/prompting.py`
- This design will be free-form but your models should be thoughtfully structured for real-world use, clarity, and style

## 2. **Leverage OpenAI's Structured Outputs**
- **Use the `response_format` parameter** to ensure the API returns output that matches your Pydantic models


```python
from pydantic import BaseModel
from openai import OpenAI

client = OpenAI()

class CalendarEvent(BaseModel):
    name: str
    date: str
    participants: list[str]

completion = client.chat.completions.parse(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "Extract the event information."},
        {"role": "user", "content": "Alice and Bob are going to a science fair on Friday."},
    ],
    response_format=CalendarEvent,
)

calendar_event = completion.choices[0].message.parsed

# event json
print(calendar_event.model_dump())
```


## 3. **Showcase Results in the Frontend**
- **Wire up the frontend** to display the normalized data in a clear, user-friendly way in `App.tsx`

## Setup

- Visit [github codespaces](https://github.com/features/codespaces) and create an instance

- Clone the repo

```
git clone https://github.com/vince21/coding-challenge-terrakotta.git
```

- Run this command

```bash
./start.sh
```

Then open http://localhost:5173

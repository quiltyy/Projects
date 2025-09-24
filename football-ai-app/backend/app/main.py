from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
import httpx

# --- Config from environment ---
PROVIDER = os.getenv("PROVIDER", "ollama").lower()
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "llama3.1")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
OPENAI_MODEL = os.getenv("OPENAI_MODEL", "gpt-4o-mini")

app = FastAPI()


# --- Schemas ---
class AnalyzeIn(BaseModel):
    text: str


class AnalyzeOut(BaseModel):
    analysis: str


# --- Prompt ---
PROMPT_TEMPLATE = """You are an expert football analyst.

TASK:
1. Summarize the game or player stats provided.
2. Highlight key takeaways (3–6 bullets).
3. Suggest any fantasy football or future performance implications.

Avoid inventing stats not given.

STATS:
{notes}
"""


# --- API: AI analysis ---
@app.post("/api/analyze", response_model=AnalyzeOut)
async def analyze(payload: AnalyzeIn):
    if not payload.text.strip():
        raise HTTPException(status_code=400, detail="No stats provided.")
    prompt = PROMPT_TEMPLATE.format(notes=payload.text)

    if PROVIDER == "ollama":
        return AnalyzeOut(analysis=await run_ollama(prompt))
    elif PROVIDER == "openai":
        if not OPENAI_API_KEY:
            raise HTTPException(status_code=400, detail="OPENAI_API_KEY not set.")
        return AnalyzeOut(analysis=await run_openai(prompt))
    else:
        raise HTTPException(status_code=400, detail=f"Unknown provider: {PROVIDER}")


# --- API: ESPN scoreboard (free, undocumented) ---
@app.get("/api/game/{league}/{date}")
async def get_game_scores(league: str, date: str):
    """
    league: 'nfl' or 'college-football'
    date: YYYYMMDD (e.g., 20250914)
    """
    url = f"https://site.api.espn.com/apis/site/v2/sports/football/{league}/scoreboard?dates={date}"
    async with httpx.AsyncClient(timeout=30.0) as client:
        r = await client.get(url)
        r.raise_for_status()
        data = r.json()

    games = []
    for ev in data.get("events", []):
        comp = ev.get("competitions", [])[0]
        home, away = comp["competitors"][0], comp["competitors"][1]
        games.append(
            {
                "home": f"{home['team']['displayName']} {home['score']}",
                "away": f"{away['team']['displayName']} {away['score']}",
                "status": comp["status"]["type"]["description"],
            }
        )
    return {"games": games}


# --- Helpers ---
async def run_ollama(prompt: str) -> str:
    url = "http://localhost:11434/api/generate"
    payload = {"model": OLLAMA_MODEL, "prompt": prompt, "stream": False}
    async with httpx.AsyncClient(timeout=60.0) as client:
        r = await client.post(url, json=payload)
        r.raise_for_status()
        return r.json().get("response", "").strip()


async def run_openai(prompt: str) -> str:
    url = "https://api.openai.com/v1/chat/completions"
    headers = {"Authorization": f"Bearer {OPENAI_API_KEY}"}
    payload = {
        "model": OPENAI_MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.2,
    }
    async with httpx.AsyncClient(timeout=60.0) as client:
        r = await client.post(url, headers=headers, json=payload)
        r.raise_for_status()
        return r.json()["choices"][0]["message"]["content"].strip()

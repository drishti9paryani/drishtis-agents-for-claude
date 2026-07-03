# Drishti's Agents for Claude

Ready-to-use agents and skills for [Claude Code](https://claude.com/claude-code).
Install once, and they work in **every project on your machine** until you delete them.

| What | Name | What it does for you |
|------|------|----------------------|
| Agent | **checkandsecure** | Audits your whole codebase for security holes, explains each one in simple words (what a hacker could actually do), fixes what's safe to fix, then **always runs a second scan** to catch anything missed, and gives you a plain-English report with a before/after risk grade. Built on Anthropic's official security-review categories. |
| Skill | **ask-drish-now** | For long build tasks: asks you **every** question, decision, and permission approval upfront in one ~10-minute batch, so you can go offline while Claude builds. Ends with a mandatory self-verification (runs tests, exercises the app for real, rechecks your original request line by line) and an honest report. |

## Install (2 minutes)

You need [Claude Code](https://claude.com/claude-code) installed. Then:

**Windows (PowerShell):**

```powershell
git clone https://github.com/drishti9paryani/drishtis-agents-for-claude.git
cd drishtis-agents-for-claude
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

**Mac / Linux:**

```bash
git clone https://github.com/drishti9paryani/drishtis-agents-for-claude.git
cd drishtis-agents-for-claude
bash install.sh
```

The installer only copies files into your `~/.claude/agents/` and `~/.claude/skills/`
folders — nothing else is touched. Restart Claude Code afterwards.

## How to use

- **Security audit:** open any project in Claude Code and say
  `run checkandsecure` (or just "security check").
- **Go-offline build:** type `/ask-drish-now` followed by your task, answer
  the one batch of questions, say "go", and walk away.

## Optional: get reminded to run the security checker every session

Add this to your `~/.claude/settings.json` (merge with what's already there):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'SECURITY REMINDER: The user has a global checkandsecure agent (5-phase security audit: detect vulnerabilities, explain in simple words, fix, mandatory re-check, report). Once per session, at a natural moment where it is relevant - e.g. after writing new code, touching auth/API/user-data handling, or before a deploy - remind the user to run the checkandsecure agent. Mention it only once per session; do not nag.'",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

## Uninstall

Delete the copied files — that's all:

- `~/.claude/agents/checkandsecure.md`
- `~/.claude/skills/ask-drish-now/` (the folder)
- the `hooks` block above from `~/.claude/settings.json`, if you added it

## Good to know

- These are **instruction files, not programs** — no code executes at install
  time, no network calls, no telemetry. You can read every line before using.
- The security checker never prints your secret values in its reports, and it
  will never "fix" a leaked API key silently — it tells you to rotate it,
  because a leaked key stays compromised even after it's removed from code.
- Agents/skills live on the **machine**, not in a Claude account — everyone
  who uses Claude Code on the same computer user profile gets them.

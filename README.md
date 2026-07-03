# Drishti's Agents for Claude

Ready-to-use agents and skills for [Claude Code](https://claude.com/claude-code).
Install once, and they work in **every project on your machine** until you delete them.

| What | Name | What it does for you |
|------|------|----------------------|
| Agent | **totem** | Audits your whole codebase for security holes, explains each one in simple words (what a hacker could actually do), fixes what's safe to fix, then **always runs a second scan** to catch anything missed, and gives you a plain-English report with a before/after risk grade. Built on Anthropic's official security-review categories. |
| Skill | **unagi** | For long build tasks: asks you **every** question, decision, and permission approval upfront in one ~10-minute batch, so you can go offline while Claude builds. Ends with a mandatory self-verification (runs tests, exercises the app for real, rechecks your original request line by line) and an honest report. |
| Agent | **rancho** | Reads your app like a product manager and suggests missing features and UI/UX improvements as simple pointers, sorted quick-wins-first. Read-only — it never touches your code. Always does a second double-check pass and explicitly labels anything it adds with "While double checking, I also thought of...". |

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
  `run totem` (or just "security check").
- **Go-offline build:** type `/unagi` followed by your task, answer
  the one batch of questions, say "go", and walk away.
- **Feature & UX ideas:** say `run rancho` (or "what should I add
  next?") in any project with a working app.

## Optional: get reminded to use these tools every session

Add this to your `~/.claude/settings.json` (merge with what's already there):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'DAILY TOOLKIT REMINDER: The user has three global tools and wants a daily nudge to use them. 1) totem agent - full security audit that detects, explains simply, fixes, then mandatorily re-checks - suggest after new code, auth/API changes, or before deploys. 2) rancho agent - read-only product review that suggests missing features and UI/UX improvements as simple pointers - suggest when an app reaches a working state or the user wonders what to build next. 3) unagi skill - batches every question and permission upfront with an ALL CLEAR message, time estimate and simple todo list so the user can go offline - suggest before any long multi-step build task. Once per session, at a natural moment, remind the user of whichever tool fits the current work. Mention once; do not nag.'",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

## Optional: "pivot" — a beep when Claude is waiting for you

Claude sometimes stops to ask a question or request permission — and if you
looked away, you don't notice and lose time. This hook plays a two-tone beep
the moment Claude is waiting on you. Add inside the same `"hooks"` block
(Windows; for Mac replace the command with `afplay /System/Library/Sounds/Ping.aiff`):

```json
"Notification": [
  {
    "hooks": [
      {
        "type": "command",
        "command": "powershell -NoProfile -Command \"[console]::beep(1000,300); [console]::beep(1400,300)\"",
        "timeout": 10,
        "async": true
      }
    ]
  }
]
```

## Uninstall

Delete the copied files — that's all:

- `~/.claude/agents/totem.md`
- `~/.claude/agents/rancho.md`
- `~/.claude/skills/unagi/` (the folder)
- the `hooks` blocks above from `~/.claude/settings.json`, if you added them

## Good to know

- These are **instruction files, not programs** — no code executes at install
  time, no network calls, no telemetry. You can read every line before using.
- The security checker never prints your secret values in its reports, and it
  will never "fix" a leaked API key silently — it tells you to rotate it,
  because a leaked key stays compromised even after it's removed from code.
- Agents/skills live on the **machine**, not in a Claude account — everyone
  who uses Claude Code on the same computer user profile gets them.

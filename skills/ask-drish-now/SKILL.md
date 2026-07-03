---
name: ask-drish-now
description: Use BEFORE starting any long or multi-step build task when the
  user wants to answer everything upfront and go offline while Claude works.
  Trigger when the user says "/ask-drish-now", "preflight", "ask me everything
  now", "I'm going offline", "batch my approvals", or gives a big task and says
  they won't be around. Front-loads ALL questions, decisions, secrets, and
  permission approvals into one upfront batch, then executes end-to-end without
  interrupting, and finishes with a mandatory self-verification that the work
  is actually correct.
---

# ask-drish-now — approve once, go offline, come back to verified work

The user's time comes in one block at the start, not scattered across the run.
Every question you would ever ask, ask NOW. Every permission you would ever
need, secure NOW. After the user gives the final go-ahead, interrupting them
is a failure of this skill.

## Phase 1 — Understand the task and scan for friction

Restate the task in 2-3 sentences. Then explore the codebase enough to
predict the whole run: which files change, which commands run (package
managers, test runners, dev servers, git), which external services are
touched, and where user judgment will be needed. Write yourself a step list.

## Phase 2 — Ask EVERYTHING upfront (one batch)

Collect every question of these kinds and ask them all now via
AskUserQuestion (batch up to 4 per call, use as few calls as possible):

- **Design decisions** — anything with more than one reasonable answer that
  changes the outcome (library choice, UI behavior, naming, scope edges).
- **Security decisions** — anything the checkandsecure or good sense
  would flag mid-run: "may I install new packages?", "is it OK to change the
  auth flow?", "should destructive step X (migration, data rewrite) run?".
- **Inputs only the user has** — API keys, account choices, URLs,
  credentials. Ask where to find them or have the user paste them into the
  appropriate .env now, before going offline.
- **Boundaries** — is git commit allowed? git push? deploy? For each
  boundary, get an explicit yes/no now.

For anything you deliberately do NOT ask, state the assumption you will make
in the plan (Phase 4) so silence = consent to that assumption.

## Phase 3 — Pre-approve permissions (the anti-popup step)

Predict every command family the run needs. Then:

1. Present the exact allowlist to the user in plain words, one line each:
   the rule, and why the task needs it.
2. On their single OK, write the rules into the project's
   `.claude/settings.local.json` under `permissions.allow` (merge, never
   replace; create the file if missing and add it to .gitignore).
3. Scope rules as narrowly as the task allows: `Bash(npm run test:*)` not
   `Bash(npm *)` when the narrow form suffices; prefer project-local
   settings over user-global so the grant dies with the project.

HARD LIMITS — never pre-approve these, no matter what:
- Broad wildcards: `Bash(*)`, blanket `Write`, blanket `Edit` outside the
  project.
- Destructive commands: `rm -rf`, `git push --force`, `git reset --hard`,
  database drops/deletes, anything irreversible. If the task truly needs
  one, ask about that SPECIFIC command in Phase 2 and run it only as
  explicitly answered — do not allowlist the pattern.
- Anything that sends secrets anywhere.

Also offer (don't force): running the built-in `/fewer-permission-prompts`
skill, which mines past transcripts for safe read-only commands worth
allowlisting permanently.

## Phase 4 — The contract, then silence

Print one final message before starting:
- The plan as a numbered step list.
- All assumptions being made (from Phase 2).
- The approved permission list.
- Stop conditions: "I will only stop before <the specific destructive or
  irreversible actions not cleared upfront>; everything else runs to the
  end."

Get one final "go". From that moment: do not ask permission for anything
covered by the contract. If something unexpected needs approval mid-run,
first reorder the remaining work to keep making progress on everything that
does not depend on it, and collect all such blocked items into ONE question
at the latest possible moment — never drip questions one at a time.

## Phase 5 — Verify correctness (mandatory, never skip)

"Done" is not done until checked. Before reporting:

1. Run the project's own gates: tests, build, typecheck, lint — whatever
   exists.
2. Exercise the change for real, not just through tests: start the app, hit
   the endpoint, load the page, run the CLI — observe the actual new
   behavior end-to-end (the built-in /verify skill is the model here).
3. Re-read the original request line by line and check each explicit
   requirement against what was built. List any requirement not met.
4. Check your own diff for collateral damage: unrelated files touched,
   debug leftovers, secrets accidentally written into code.

## Phase 6 — Report

One message the user can read cold when they come back online:
- **What was built** — plain words, requirement by requirement.
- **Verification results** — what was run, what passed, what failed, with
  honest output. Never say "should work"; say what was observed.
- **Assumptions used** — so the user can veto any after the fact.
- **Left undone / needs you** — anything blocked or deferred, with the
  exact next step.

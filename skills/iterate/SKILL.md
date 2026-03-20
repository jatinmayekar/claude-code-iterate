---
name: iterate
description: >
  Self-correcting agentic loop. Executes a task, evaluates output against
  success criteria, and retries with targeted fixes until all criteria pass
  or max iterations reached. Use when a task needs to meet specific quality
  bars, pass tests, match a spec, or satisfy multiple requirements that
  are unlikely to all be met on the first attempt.
argument-hint: "<task> | <criteria, comma-separated> [| max:<N>]"
---

# Iterate: Self-Correcting Agentic Loop

You are executing a self-correcting work loop. Follow this protocol exactly.

## Step 0: Parse Input

Parse `$ARGUMENTS` using this format:

```
<task> | <criteria1, criteria2, ...> [| max:<N>]
```

- **Task**: Everything before the first `|` is the task description.
- **Criteria**: Everything between the first and second `|` is a comma-separated list of success criteria. Each criterion must be independently evaluable.
- **Max iterations**: If a third segment contains `max:<N>`, use N as the iteration limit. Default: **5**.

**If the user provides no `|` separator**, treat the entire input as the task and infer 3-5 concrete, testable success criteria from the task description. State the inferred criteria clearly and ask the user to confirm before proceeding. Do not begin the loop until confirmation is received.

## Step 1: Execute Loop

For each iteration (starting at 1):

### A — WORK

Execute the task fully. On iteration 1, start from scratch. On iteration 2+, apply **only the targeted fixes** identified in the previous evaluation. Do not redo work that already passes.

### B — EVALUATE

Evaluate the output against **every** success criterion independently. For each criterion, produce:

```
[PASS] or [FAIL] — criterion text — one-sentence evidence
```

**Verification rules:**
- Do NOT evaluate from memory. Actually inspect the output — read the file, run the code, check the result.
- If the task produced a file, read it back and verify each criterion against the actual content.
- If the task produced visual output (chart, image, HTML), describe what you actually see, not what you intended.
- Be honest. If something barely passes, say so. Do not rubber-stamp your own work.
- Common self-evaluation failures: overlapping text, raw numbers instead of formatted, wrong positioning — check for these.

### C — DECIDE

- **ALL criteria [PASS]**: Proceed to Step 2 (Done).
- **Any criterion [FAIL] AND iterations remaining**: Proceed to D.
- **Any criterion [FAIL] AND max iterations reached**: Proceed to Step 2 (Done) with partial success.

### D — DIAGNOSE AND PLAN FIX

For each [FAIL] criterion:

1. **Root cause** — what specifically is wrong (not the symptom, the cause).
2. **Fix** — the concrete change you will make in the next iteration.
3. **Risk** — which [PASS] criteria your fix might break.

**Stuck-loop detection**: If the same criterion has failed 3 consecutive times with the same root cause, STOP. Tell the user what is stuck and why, and ask for guidance rather than burning remaining iterations.

Then return to **A** for the next iteration.

## Step 2: Done

When the loop terminates (success, partial, or max reached), output this summary:

```
═══ ITERATE COMPLETE ═══
Status: [ALL CRITERIA MET | PARTIAL — X/Y criteria met | MAX ITERATIONS REACHED]
Iterations: <completed> / <max>

Criterion Results:
  [PASS] criterion 1 — evidence
  [PASS] criterion 2 — evidence
  [FAIL] criterion 3 — why it still fails

Iteration Log:
  #1: Full task execution → X/Y criteria passed
  #2: Fixed <what> → X/Y criteria passed
  #3: Fixed <what> → Y/Y criteria passed

Key Decisions:
  - <Most important tradeoff or fix applied>
═══════════════════════
```

## Rules

1. **Never skip evaluation.** Every iteration must include Step B with explicit [PASS]/[FAIL] per criterion.
2. **Never repeat work that already passes.** Targeted fixes only after iteration 1.
3. **Be honest in evaluation.** Do not inflate results. If it barely passes, note it.
4. **Stop early if all criteria pass.** Do not iterate for the sake of iterating.
5. **Escalate when stuck.** Same failure 3 times = ask the user, don't loop.
6. **Show your work.** Each iteration's evaluate and diagnose steps must be visible to the user.

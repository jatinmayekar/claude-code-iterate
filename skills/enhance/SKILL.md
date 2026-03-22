---
name: enhance
description: >
  Prompt enhancement skill. Takes a vague task description, identifies what's
  missing or ambiguous, rewrites it into a structured prompt using prompt
  engineering best practices (specificity, chain-of-thought, role context,
  output format), generates testable success criteria, and executes with
  built-in verification. Turns "build me a dashboard" into a complete spec.
argument-hint: "<vague task description>"
---

# Enhance: Prompt Enhancement + Requirements Discovery + Verification

You are a prompt enhancement engine. The user has given you a vague or underspecified task. Your job is NOT to just execute it — it's to **make the prompt better first**, then execute the improved version, then verify the output.

Follow this protocol exactly.

## Step 0: Receive Input

Take `$ARGUMENTS` as the user's raw task description. This is likely vague, missing details, or ambiguous. That's expected — most users write prompts this way.

## Step 1: Analyze the Prompt

Identify what's wrong with the prompt as-is. Check for:

- **Vagueness**: Words like "good", "professional", "proper", "nice", "works" — no measurable definition
- **Missing scope**: No file paths, no language specified, no size/length constraints
- **Missing requirements**: No error handling mentioned, no edge cases, no input validation
- **Missing output format**: No file format, no structure, no where-to-save
- **Missing context**: No target audience, no tech stack, no dependencies
- **Ambiguity**: Could be interpreted multiple ways

List each issue found. Be specific.

## Step 2: Discover Requirements

For each gap identified in Step 1, infer the most likely requirement based on the task context. Apply these heuristics:

- **Code tasks**: Assume error handling, input validation, type hints, and a runnable file
- **Web/HTML tasks**: Assume responsive design, accessible markup, modern CSS, sample data
- **Data tasks**: Assume the user wants visualizations, summary statistics, and saved output
- **API tasks**: Assume proper status codes, validation, error responses, and a health endpoint
- **General**: Assume the user wants a complete, working artifact — not a snippet

List the inferred requirements clearly.

## Step 3: Rewrite the Prompt

Transform the vague input into a structured, specific prompt. Apply these techniques (from [Anthropic's prompt engineering best practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-prompting-best-practices)):

### 3a — Add specificity
Replace vague words with measurable criteria.
- "looks professional" → "uses a consistent color palette (max 5 colors), has proper spacing (16px+ padding), readable typography (16px+ body text)"
- "handles errors" → "returns appropriate HTTP status codes (400, 404, 409, 500), validates all input fields, catches exceptions with descriptive messages"
- "works" → "runs without errors, produces expected output, handles edge cases (empty input, invalid input)"

### 3b — Add structure
Organize the prompt with clear sections:
- What to build
- Technical constraints (language, libraries, file path)
- Specific requirements (numbered list)
- Output format

### 3c — Add role context
Prepend an appropriate role:
- Code: "You are a senior software engineer writing production-quality code."
- Web: "You are a senior frontend developer building a modern, accessible web page."
- Data: "You are a data analyst creating a comprehensive, insight-driven report."

### 3d — Add output format
Specify exactly what the output should look like:
- File path and format
- Whether to include comments/docstrings
- Whether to include sample data or tests

## Step 4: Generate Verification Criteria

Create 4-6 **testable** success criteria for the enhanced prompt. Each criterion must be independently verifiable by reading the file, running the code, or checking specific attributes.

Good criteria:
- "File runs without errors: `python3 <file>`"
- "Contains at least 3 sections/components"
- "Has responsive CSS with `@media` queries"
- "All functions have error handling (try/except or validation)"

Bad criteria (too vague — do NOT use):
- "Looks good"
- "Works properly"
- "Is professional"

## Step 5: Present to User

Show the user:

```
═══ ENHANCED PROMPT ═══

Original: <their vague input>

Issues found:
  1. <issue>
  2. <issue>
  ...

Enhanced task:
  <the rewritten, specific prompt>

Verification criteria:
  1. <testable criterion>
  2. <testable criterion>
  ...

═══════════════════════
```

Then ask: **"Proceed with this enhanced prompt? (Or tell me what to adjust.)"**

Wait for confirmation before executing. Do NOT proceed without it.

## Step 6: Execute

Run the enhanced prompt. Apply the role context and structured requirements from Step 3. This is a normal task execution — write the code, create the file, build the artifact.

## Step 7: Verify

After execution, verify output against **every** criterion from Step 4. For each criterion:

```
[PASS] or [FAIL] — criterion text — evidence
```

**Verification rules** (reused from iterate):
- Do NOT evaluate from memory. Actually inspect the output — read the file, run the code, check the result.
- If the task produced a file, read it back and verify each criterion against the actual content.
- Be honest. If something barely passes, say so.

## Step 8: Report

Output the final report:

```
═══ ENHANCE COMPLETE ═══
Original prompt: <what user typed>
Enhanced prompt: <what was actually executed>

Verification Results:
  [PASS] criterion 1 — evidence
  [PASS] criterion 2 — evidence
  ...

Enhancements applied:
  - <what was added/clarified>
  - <what was added/clarified>

Quality delta:
  - Original prompt would have missed: <what the raw prompt wouldn't have covered>
═══════════════════════
```

## Rules

1. **Always enhance first.** Never execute a vague prompt as-is.
2. **Be specific.** Replace every vague word with a measurable criterion.
3. **Wait for confirmation.** Show the enhanced prompt and get user approval before executing.
4. **Verify honestly.** Read files back, run code, check results. Don't rubber-stamp.
5. **Show the delta.** Make it clear what the enhancement added that the user didn't specify.

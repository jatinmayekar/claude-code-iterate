# iterate

**Self-correcting agentic loop for Claude Code.**

Work → Evaluate → Iterate → Done.

Claude executes your task, evaluates its own output against your success criteria, diagnoses failures, applies targeted fixes, and repeats — until every criterion passes or max iterations are reached.

## Why

[Research shows](RESEARCH.md) most users write vague, underspecified prompts — and benchmarks don't reflect this reality. When you say "make it work" or "looks professional," a single-shot LLM just guesses what you mean. `iterate` turns that vague intent into a structured quality loop:

1. **Infers what "done" means** — decomposes vague goals into testable criteria
2. **Actually verifies its work** — reads files back, runs code, checks assertions (not self-assessment from memory)
3. **Fixes what's wrong** — targeted corrections, not full restarts

No one has shipped this as a reusable Claude Code skill. This is it.

## Install

**From GitHub:**

```bash
claude plugin install jatinmayekar/claude-code-iterate
```

**Local testing:**

```bash
claude --plugin-dir /path/to/claude-code-iterate
```

## Usage

```
/iterate <task> | <criteria, comma-separated> [| max:<N>]
```

### Examples

**Code generation with quality criteria:**
```
/iterate write a Python function that sorts a list | handles empty list, handles duplicates, has type hints, includes docstring
```

**Fix failing tests:**
```
/iterate fix the failing test in test_auth.py | all tests pass, no new warnings
```

**Creative writing with constraints:**
```
/iterate write a haiku about recursion | exactly 5-7-5 syllables, references recursion, no cliches
```

**Custom iteration limit:**
```
/iterate refactor the auth middleware | no breaking changes, passes all tests, under 100 lines | max:8
```

**No criteria (auto-inferred):**
```
/iterate add input validation to the signup form
```
Claude infers success criteria and asks you to confirm before starting.

## How It Works

1. **WORK** — Execute the task (or apply targeted fixes on iteration 2+)
2. **EVALUATE** — Check every criterion independently: `[PASS]` or `[FAIL]` with evidence
3. **DECIDE** — All pass? Done. Any fail? Diagnose and fix. Max reached? Report partial.
4. **DIAGNOSE** — Root-cause each failure, plan the fix, assess risk to passing criteria
5. **Repeat** until done

### Smart Features

- **Auto-infer criteria** — Skip the `|` and Claude proposes testable criteria for your approval
- **Stuck-loop detection** — Same criterion fails 3x with same root cause? Claude asks you for help instead of burning iterations
- **Targeted fixes only** — After iteration 1, only fixes what's broken. Doesn't redo passing work
- **Honest self-evaluation** — Won't rubber-stamp its own output

### Tested

16 tests across code generation, charts, HTML landing pages, PowerPoint presentations, React components, SVG diagrams, algorithms, and [BigCodeBench-Hard](https://huggingface.co/datasets/bigcode/bigcodebench-hard) benchmark tasks. Tested with Opus, Sonnet, and Haiku (including low-effort mode).

**Self-correction in action:**

| Test | What happened | How iterate helped |
|------|--------------|-------------------|
| SQL Builder | Invalid import on iteration 1 | Caught error, fixed on iteration 2 |
| K-Means (BigCodeBench/92) | sklearn unavailable | Reimplemented K-means from scratch using numpy |
| Orbital Mechanics | Assertion tolerance too tight | Verified physics was correct, diagnosed test spec issue |
| Contradictory Criteria | `return 42` and `return 99` both required | Creative solution using file-based state |

**Bug found during testing:** The evaluation step was too weak — Haiku rubber-stamped its own output. Fixed by adding verification rules (read files back, run code, inspect actual output instead of evaluating from memory).

Full results: [`tests/TEST_RESULTS.md`](tests/TEST_RESULTS.md)

### Output

```
═══ ITERATE COMPLETE ═══
Status: ALL CRITERIA MET
Iterations: 3 / 5

Criterion Results:
  [PASS] handles empty list — returns [] for empty input
  [PASS] handles duplicates — [3,1,3,2] → [1,2,3,3]
  [PASS] has type hints — def sort_list(items: list[int]) -> list[int]
  [PASS] includes docstring — Google-style docstring with examples

Iteration Log:
  #1: Full implementation → 2/4 passed (missing type hints, docstring)
  #2: Added type hints and docstring → 3/4 passed (docstring lacked examples)
  #3: Added examples to docstring → 4/4 passed

Key Decisions:
  - Used Google-style docstring format for consistency with project
═══════════════════════
```

## Roadmap

- [ ] Test runner integration (auto-detect pytest/jest as eval criteria)
- [ ] Persistent iteration logs (`.claude/iterate-logs/`)
- [ ] Fork mode for long-running loops
- [ ] Skill composability (`/iterate /deploy | health check passes`)

## License

MIT

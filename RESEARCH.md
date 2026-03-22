# Research: Why Self-Correcting Loops Matter More for Vague Prompts

## Hypotheses

**H1**: When users provide vague/underspecified criteria (e.g., "it should work", "looks professional"), iterate's structured evaluation loop produces higher-quality output than a single-shot response — because iterate decomposes vague goals into testable sub-criteria and forces actual verification.

**H2**: Iterate's auto-infer feature (no `|` separator) is more effective than its vague-criteria handling (with `|`) — because auto-infer proactively discovers requirements instead of accepting subjective criteria at face value.

## The Problem

### Users don't write good prompts

It is "unrealistic to expect users to master the art of designing optimal prompts or to invest a significant amount of time in doing so" ([On the Worst Prompt Performance of LLMs, 2024](https://arxiv.org/html/2406.10248v4)). The worst-prompt performance of Llama-2-70B-chat shows a **45.48 point difference** in win-rate depending on phrasing.

A [Taxonomy of Prompt Defects](https://arxiv.org/html/2509.14404v1) (2025) found that prompt engineering "largely operates on an ad-hoc basis" — bad prompts affect both casual users and professional developers.

### Benchmarks don't test what matters

[Inherent Limitations of Benchmarks for Evaluating LLMs](https://arxiv.org/html/2502.14318v1) (2025) found that benchmark performance is "highly unsuitable as a metric for generalisable competence." Real-world queries don't segregate task instructions cleanly like benchmarks do. Accuracy swings **25 percentage points** from answer reordering alone.

### Underspecification is the norm

["What Prompts Don't Say"](https://arxiv.org/abs/2505.13360) (Yang et al., 2025):

- LLMs can infer missing requirements **41.1% of the time** — but this is fragile
- Underspecified prompts are **2x as likely to regress** across model/prompt changes
- Simply specifying all requirements doesn't help — models get overwhelmed
- **Winning approach: proactive requirements discovery, evaluation, and monitoring**

### Self-correction needs external feedback

[When Can LLMs Actually Correct Their Own Mistakes?](https://direct.mit.edu/tacl/article/doi/10.1162/tacl_a_00713/125177/) (MIT Press, 2025) found self-correction works when **reliable external feedback** is available. Without it, models suffer from self-bias. [CorrectBench](https://correctbench.github.io/) (2025) showed **5.2% accuracy gains** from structured self-correction on math.

## Test Methodology

### Phase 1: Well-Defined Tasks (Tests 7-22)

Ran 16 tests with specific, testable criteria across code, charts, HTML, PPTX, SVG, React, algorithms, and [BigCodeBench-Hard](https://huggingface.co/datasets/bigcode/bigcodebench-hard) benchmark tasks. Used Haiku + low effort to stress-test with the weakest model.

### Phase 2: Vague Prompt Tests (Tests 23-27)

Ran 5 tests with intentionally vague/underspecified criteria to simulate real user behavior:

| Test | Prompt | Criterion |
|------|--------|-----------|
| 23 | Write a web scraper | "it should work" |
| 24 | Create an HTML dashboard | "looks professional" |
| 25 | Write a REST API endpoint | "handles errors properly" |
| 26 | Analyze CSV and create report | "make it insightful" |
| 27 | Build a calculator app | (none — auto-infer) |

## Results

### Phase 1: Well-defined tasks pass too easily

12 of 16 tests passed on iteration 1, even with Haiku + low effort. 4 tests triggered multi-iteration (Tests 8, 14, 17, 21) — but only due to environment issues or contradictory criteria, not genuine quality failures.

**Conclusion**: Well-defined tasks with specific criteria don't showcase iterate's value. Benchmarks with clean specifications don't expose the real gap.

### Phase 2: Vague prompts reveal the real behavior

**Auto-infer path (no `|`) — Tests 23, 27:**
- Test 23: Iterate recognized "it should work" as too vague, decomposed into 3 testable criteria (syntax valid, retrieves data, extracts structured output), asked for confirmation
- Test 27: Inferred 5 testable criteria from "build a calculator", asked for confirmation
- Both **did NOT rubber-stamp** — proactive requirements discovery worked exactly as the research predicts

**Vague criteria path (with `|`) — Tests 24, 25, 26:**
- Test 24 ("looks professional"): Accepted as-is, self-evaluated with detailed evidence, rubber-stamped
- Test 25 ("handles errors properly"): Partially expanded to 4 evaluation points — better behavior
- Test 26 ("make it insightful"): Accepted as-is, but output quality was genuinely high

## Conclusions

### H1: Partially confirmed

Iterate's value with vague prompts depends on which path triggers. When auto-infer activates (no `|`), the structured loop produces measurably better behavior — decomposing vague goals into concrete criteria. When vague criteria are given with `|`, behavior is inconsistent (sometimes rubber-stamps, sometimes expands).

### H2: Confirmed

Auto-infer (no `|`) > vague criteria (with `|`). The auto-infer path proactively discovers requirements and asks for confirmation. The `|` path accepts whatever the user wrote, even if too vague to evaluate independently.

### Design improvement identified

SKILL.md should instruct iterate to **decompose vague criteria even when `|` is present** — not just when no separator exists. This closes the gap between the two paths.

**Fix applied**: Added vague-criteria decomposition rule to Step 0 in SKILL.md.

### A/B Comparison: Vague Prompts With vs Without Iterate

We ran the same vague prompts (Tests 24-26) both with iterate and as raw single-shot Haiku:

| Test | With Iterate | Without Iterate | Winner |
|------|-------------|-----------------|--------|
| Dashboard ("looks professional") | 357 lines, basic design | 608 lines, dark luxury theme, animations | **Raw wins** |
| API ("handles errors properly") | 151 lines, Flask | 187 lines, FastAPI + SQLAlchemy + Pydantic | **Raw wins** |
| Report ("make it insightful") | 150 lines | 163 lines, comparable depth | **~Tie** |

**None of the iterate runs triggered a second iteration.** All passed self-evaluation on attempt 1. The iterate overhead (parsing, evaluating, summary block) actually constrained the output compared to raw single-shot where the model goes all-out.

### H1: Not confirmed for vague prompts

Iterate's structured evaluation loop does NOT produce better output than single-shot when vague criteria pass on iteration 1. The self-evaluation step rubber-stamps subjective criteria ("looks professional" → PASS with evidence list) without pushing for improvement.

### H2: Confirmed

Auto-infer (no `|`) is genuinely more effective than vague criteria (with `|`). Tests 23 and 27 showed iterate refusing to proceed, decomposing vague goals into testable criteria, and asking for confirmation. This is requirements discovery — the actual value.

### Where iterate actually adds value

The value is NOT in making single-pass outputs better. It's in two specific scenarios:

1. **Requirements discovery** (Tests 23, 27) — when users give no criteria, iterate stops and asks "what do you actually mean?" instead of guessing. This aligns with the recommendation from Yang et al. (2025).

2. **Recovery from real failures** (Tests 8, 14, 21) — fixing broken imports, missing libraries, contradictory requirements. The structured EVALUATE → DIAGNOSE → FIX cycle helps when something actually breaks.

### What iterate does NOT help with

- Vague criteria that pass on iteration 1 — the model rubber-stamps itself
- Well-defined tasks — even Haiku nails these in one shot
- Output quality on subjective criteria — raw single-shot produces equal or richer output

## The Pivot: Fix the Prompt, Not the Output

### Key insight

Our testing proved that **output iteration** (execute → self-evaluate → retry) adds minimal value. What actually worked was **input improvement** — requirements discovery (auto-infer) and forced verification. This suggests the skill should pivot from iterating on outputs to enhancing inputs.

### What already exists

Prompt optimization tools exist but none are packaged as Claude Code skills:

- [Anthropic's Prompt Generator](https://docs.anthropic.com/en/docs/prompt-generator) — metaprompt that rewrites prompts following best practices (chain-of-thought, XML tags, structured output)
- [DSPy](https://dspy.ai/) (Stanford) — treats prompts as code, auto-optimizes with hill-climbing. Philosophy: "programming, not prompting"
- [Meta's prompt-ops](https://github.com/meta-llama/prompt-ops) — open-source prompt optimization CLI
- [Evidently](https://www.evidentlyai.com/blog/automated-prompt-optimization) — raised accuracy from 64% to 96% with automatic prompt rewriting
- [PromptPerfect](https://promptperfect.jina.ai/) — paste any prompt, get it rewritten for target model

### The gap

None of these are Claude Code skills. Nobody has packaged prompt enhancement + requirements discovery + verification enforcement into a single reusable skill that works inside the Claude Code workflow.

### What exists inside Claude Code (verified March 2026)

| Tool | What it does | Prompt enhancement? |
|------|-------------|-------------------|
| `/simplify` (built-in) | Code cleanup: reuse, quality, efficiency review | No — code only |
| `/review` (built-in) | Code review | No |
| `/batch`, `/loop`, `/debug` (built-in) | Execution utilities | No |
| Anthropic Prompt Generator | Metaprompt in Console, rewrites prompts | Yes — but web-only, not a skill |
| Anthropic Prompt Library | 50+ templates | Copy-paste, not automated |
| `/common-ground` ([jeffallan](https://github.com/jeffallan/claude-skills)) | Surfaces hidden assumptions | Closest — but limited scope |
| Context Engineering Kit ([NeoLabHQ](https://github.com/NeoLabHQ/context-engineering-kit)) | Context patterns | Context, not prompt rewriting |
| 340+ community plugins | Various | None do prompt enhancement |

### The gap

**No Claude Code skill exists that takes a vague user prompt and:**
1. Rewrites it using prompt engineering best practices (chain-of-thought, specificity, structured output)
2. Discovers missing requirements (proactive requirements discovery per Yang et al.)
3. Adds verification criteria automatically
4. Enforces checks on output quality

### Proposed direction

Instead of:
> "Execute → self-evaluate → retry" (output iteration — didn't add value in testing)

The skill should do:
> "Enhance prompt → discover requirements → execute → verify" (input improvement + verification)

This combines:
1. **Prompt rewriting** — apply Anthropic's prompt engineering techniques (chain-of-thought, structured output, specificity) to the user's vague input
2. **Requirements discovery** — the auto-infer feature that actually worked in our testing (Tests 23, 27)
3. **Verification enforcement** — the forced evaluation step that caught real failures (Tests 8, 14, 21)
4. **Failure recovery** — if verification fails, diagnose and fix (the iterate loop, but only when actually needed)

### Supporting research

- DSPy's core thesis: "Treat prompts as code" ([arxiv 2025](https://arxiv.org/html/2507.03620v1)) — optimize the input programmatically, don't hand-tune outputs
- Evidently showed prompt optimization alone raised accuracy 64% → 96% — no output iteration needed
- Yang et al. (2025): "requirements-aware prompt optimization improves performance by 4.8% over baselines"
- Our own data: auto-infer (input improvement) worked; output iteration on vague criteria did not

## References

1. Yang, C. et al. (2025). "What Prompts Don't Say: Understanding and Managing Underspecification in LLM Prompts." [arXiv:2505.13360](https://arxiv.org/abs/2505.13360)
2. "Line Goes Up? Inherent Limitations of Benchmarks for Evaluating Large Language Models." (2025). [arXiv:2502.14318](https://arxiv.org/html/2502.14318v1)
3. "On the Worst Prompt Performance of Large Language Models." (2024). [arXiv:2406.10248](https://arxiv.org/html/2406.10248v4)
4. Huang, J. et al. (2025). "When Can LLMs Actually Correct Their Own Mistakes? A Critical Survey." [MIT Press TACL](https://direct.mit.edu/tacl/article/doi/10.1162/tacl_a_00713/125177/)
5. "A Taxonomy of Prompt Defects in LLM Systems." (2025). [arXiv:2509.14404](https://arxiv.org/html/2509.14404v1)
6. "Can LLMs Correct Themselves? CorrectBench." (2025). [arXiv:2510.16062](https://arxiv.org/html/2510.16062v1)

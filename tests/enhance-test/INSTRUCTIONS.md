# Enhance Skill — End-to-End Test Instructions

## Setup

The test folders are pre-created with isolated directories. Give write permissions only within each folder.

## Test A: Dashboard

```bash
cd /path/to/claude-code-iterate/tests/enhance-test/dashboard
claude --plugin-dir /path/to/claude-code-iterate
```

Then type:
```
/enhance build me a sales dashboard
```

Review the enhanced prompt, confirm, let it execute and verify.

## Test B: API

```bash
cd /path/to/claude-code-iterate/tests/enhance-test/api
claude --plugin-dir /path/to/claude-code-iterate
```

Then type:
```
/enhance write a user registration API endpoint
```

## Test C: Report

```bash
cd /path/to/claude-code-iterate/tests/enhance-test/report
claude --plugin-dir /path/to/claude-code-iterate
```

Then type:
```
/enhance analyze the tech jobs data and create a report
```

(`tech_jobs.csv` is already in this folder)

## After All Tests

Check the generated files in each folder. Compare against running the same prompts without `/enhance` (raw single-shot) to see the quality difference.

## Sharing This Project

If you clone this repo and want to run these tests yourself:

1. **Install the plugin**:
   ```bash
   claude plugin install jatinmayekar/claude-code-iterate
   ```
   Or clone and use `--plugin-dir`:
   ```bash
   git clone https://github.com/jatinmayekar/claude-code-iterate.git
   claude --plugin-dir ./claude-code-iterate
   ```

2. **Run any test**: `cd` into a test folder and run the `/enhance` command above.

3. **What you need**: Just Claude Code CLI installed. No API key needed if you're logged in via `claude login`. No Docker required.

4. **What happens**: `/enhance` will analyze your vague prompt, show you what's missing, generate a structured spec with testable criteria, ask you to confirm, then execute and verify. All output stays in the folder you're in.

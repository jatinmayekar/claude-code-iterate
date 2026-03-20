#!/bin/bash
# =============================================================
# Test Runner for claude-code-iterate
# =============================================================
# This script prints each test case for manual execution.
# Run Claude Code with the plugin, then paste each command.
#
# Usage:
#   claude --plugin-dir /path/to/claude-code-iterate
#   Then run each test below inside the Claude Code session.
# =============================================================

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "═══════════════════════════════════════════════════"
echo " iterate Skill — Test Suite"
echo " Plugin dir: $PLUGIN_DIR"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Launch Claude Code with:"
echo "  claude --plugin-dir $PLUGIN_DIR"
echo ""
echo "Then run each test case below. Record results in tests/TEST_RESULTS.md"
echo ""
echo "─────────────────────────────────────────────────"
echo "TEST 1: Happy Path — Code Generation"
echo "─────────────────────────────────────────────────"
echo '/iterate write a Python function that checks if a string is a palindrome | handles empty string, case-insensitive, has type hints, includes docstring'
echo ""
echo "─────────────────────────────────────────────────"
echo "TEST 2: Auto-Infer Criteria"
echo "─────────────────────────────────────────────────"
echo '/iterate add input validation to a signup form'
echo ""
echo "─────────────────────────────────────────────────"
echo "TEST 3: Multi-Iteration with Failures"
echo "─────────────────────────────────────────────────"
echo '/iterate write a bash script that backs up a directory | accepts source and dest as args, validates both dirs exist, creates timestamped backup name, logs to stdout, handles spaces in paths | max:3'
echo ""
echo "─────────────────────────────────────────────────"
echo "TEST 4: Early Stop"
echo "─────────────────────────────────────────────────"
echo '/iterate print hello world in Python | outputs exactly "hello world", is one line'
echo ""
echo "─────────────────────────────────────────────────"
echo "TEST 5: Stuck Loop Detection"
echo "─────────────────────────────────────────────────"
echo '/iterate write a function that returns true | returns true, returns false simultaneously, is valid Python | max:5'
echo ""
echo "─────────────────────────────────────────────────"
echo "TEST 6: Custom Max Iterations"
echo "─────────────────────────────────────────────────"
echo '/iterate write a haiku about recursion | exactly 5-7-5 syllables, references recursion, no cliches | max:8'
echo ""
echo "─────────────────────────────────────────────────"
echo "TEST 7: Chart Creation (Visual / Multi-Iteration)"
echo "─────────────────────────────────────────────────"
echo "PRE-REQ: Ensure /tmp/iterate-chart-test/tech_jobs.csv exists"
echo '/iterate create a Python matplotlib chart from /tmp/iterate-chart-test/tech_jobs.csv showing US tech job growth 2020-2025. Save as /tmp/iterate-chart-test/tech_jobs_chart.png | chart has a title and axis labels, uses a dark professional theme with non-default colors, data points are labeled with values, includes a legend positioned outside the plot area, saved as PNG at 300 DPI with tight layout | max:2'
echo ""
echo "─────────────────────────────────────────────────"
echo "META TEST: Self-Referential"
echo "─────────────────────────────────────────────────"
echo '/iterate refactor the TEST_RESULTS.md to be cleaner | all test results are present, formatting is consistent, no typos | max:3'
echo ""
echo "═══════════════════════════════════════════════════"
echo " Done. Record all results in tests/TEST_RESULTS.md"
echo "═══════════════════════════════════════════════════"

---
name: profile-python
description: >
  Use when asked to profile, diagnose latency, or investigate memory issues in async Python systems,
  especially pipelines with concurrent LLM or API calls.
  Pinpoints the exact functions responsible for latency, tail spikes, and memory jumps,
  then produces a prioritized report of fixes.
user-invocable: true
allowed-tools: Bash(sudo py-spy *)
---

# Python Profiling (Async + LLM/API heavy)

## Quick mental model

Tail the log for phase timing, find the slow phases, then trace each back to the
orchestrator method in code. Fix the concurrency pattern, not the Python frames.

## Typical invocation

The user runs a pipeline that outputs a log file:

```bash
caffeinate time uv run python scripts/run_local.py \
    --query "..." \
    --output report.json 2>&1 | tee output.log
```

Monitor `output.log` while the pipeline runs to identify slow phases from log timestamps,
then trace them back to the responsible code. A single agent handles both observation and
code investigation. Do not use agent teams: each step depends on the previous one's findings.
If memory issues are suspected, also sample RSS (Resident Set Size) in the background.

---

## Step 1: Correlate phases to timing

Before investigating anything, establish a timeline.

- Extract pipeline phase markers from the log (start/end of each major step).
- Identify which phases are slow, have high variance, or show unusual patterns (retries, repeated errors).
- If memory is a concern, sample RSS every 1-2s via `ps -p PID -o rss=` in a background loop. Align with phase boundaries to find step-function jumps at fan-out points.

Rule: Treat any "what caused it" explanation as a hypothesis until you can point to the exact
orchestrator method and its concurrency pattern.

## Step 2: Identify the fan-out orchestrator immediately

After the first correlated spike, do not wait for later phases.

- Search for the log marker string in code.
- Jump to the logger callsite.
- Find the function/method that creates tasks and awaits them (`gather`, `create_task`, `as_completed`).
- Name exact locations: `module.py:Class.method`.

## Step 3: CPU profiling is secondary for I/O-bound pipelines

Use CPU sampling to confirm whether you're CPU-bound or waiting.
If CPU is low, focus on orchestration and wait time, not micro-optimizing Python frames.

---

## Profiling tools

### Live / already running (no restart needed)

**CPU sampling (py-spy):**
py-spy attach requires sudo on macOS. If unavailable, skip CPU sampling and rely on phase correlation + orchestrator inspection.

```bash
sudo py-spy top --pid <PID> --subprocesses
sudo py-spy record --pid <PID> --output cpu_profile.svg --rate 50 --subprocesses --duration 120
```

**Event loop health:**
Set `PYTHONASYNCIODEBUG=1` before the run to catch unawaited coroutines and slow callbacks without code changes.
At runtime, `loop.slow_callback_duration` flags event loop blockers.

### Rerunnable (recommended for attribution)

- **Async latency attribution:** pyinstrument with `async_mode` enabled around the job/request.
- **Memory attribution:** tracemalloc snapshot diffs around the suspicious phase.

---

## Concurrency failure patterns to look for

These are easy to miss and high ROI. Actively check for each:

- **Unbounded concurrency:** missing semaphore/limiter per dependency
- **`gather()` over huge lists:** causes buffering and peak memory from all responses held simultaneously
- **Long-tail calls holding phases hostage:** one slow call blocks the entire gather
- **Retry storms:** no jitter, too many retries, synchronized retry waves
- **Event loop blockers:** sync HTTP, sync file I/O, CPU-heavy work on the loop thread
- **Per-task context duplication:** building large prompts/docs N times instead of sharing
- **HTTP connection pool exhaustion:** httpx/aiohttp pool limits silently serialize concurrent requests

---

## Code navigation: investigate, don't explore

Only read code that is directly relevant to an issue you have already observed in the log.
Do not read files speculatively to "understand the codebase." If a phase hasn't started yet,
its code is not relevant yet.

**What drives a code read:**
- A phase marker in the log that shows unexpected duration or errors → grep for that event string
- A concurrency spike you need to trace → grep for `gather`, `create_task`, `as_completed`, `Semaphore`
- A connection or timeout issue → grep for HTTP client initialization, pool sizes, timeout configs

**What does NOT justify a code read:**
- "Let me understand the pipeline structure" (you're profiling, not onboarding)
- Reading a file for a phase that hasn't run yet
- Reading an entire 1000+ line file when you need one function

## While waiting on long-running phases

Do not idle-poll with sleep loops. If the pipeline is blocked on I/O (e.g., hundreds of LLM calls
in flight), use that time to investigate the code paths responsible for the current phase.
Check the log periodically (every 30-60s) but spend the gaps doing targeted code reads
and building your findings report.

---

## Output: Top findings report

Produce a ranked report with 3-7 items. After each major phase completes, emit an interim
findings report in the format below. Do not wait for the full run. Do not substitute a timeline
table for a findings report. A timeline is useful context but it is not a finding.

Each item:

- **Location:** exact `module.py:Class.method`
- **Evidence:** phase timing, RSS delta if relevant
- **Diagnosis:** which concurrency pattern from the list above
- **Next step:** one concrete, minimal-disruption change
- **Validation:** what metric should improve (p95/p99 latency, peak RSS, error/retry rate)

# Optional: Observability gaps

At the end of the report, note any gaps in logging or instrumentation that made profiling
harder than it needed to be. Frame these as low-effort improvements for next time, not criticism.
Keep this section short: 2-4 concrete suggestions, each one sentence.
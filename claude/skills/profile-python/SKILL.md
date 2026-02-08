---
name: profile-python
description: >
  Use when Python code is slow, latency is high, CPU is pegged, memory grows over time,
  or the user asks to profile/optimize. Focus on 80/20 workflows:
  (1) time/latency: pyinstrument locally, cProfile when call counts matter
  (2) memory leaks: tracemalloc snapshot diffs first, memray when native extensions or production realism matter
  (3) compute: use Scalene-style separation of Python vs native when CPU is high but hotspots are unclear
  (4) async: pyinstrument with async mode for FastAPI/async Python, or log-based middleware for endpoint-level latency
---

# Python Profiling

## First: pick the question

If the problem is "slow" or "high latency":
- Local repro: pyinstrument
- Need deterministic call counts: cProfile + pstats (sort by cumulative)

If the problem is "memory keeps growing":
- Start: tracemalloc snapshot diff (pure Python allocations)
- If growth is in native code or tracemalloc is inconclusive: memray

If the problem is "CPU is high" but the code uses NumPy / native libs:
- Use a profiler that separates Python vs native time and highlights copying

If the problem is "async endpoint is slow" or "event loop is blocked":
- pyinstrument with async_mode="enabled" to see awaited time
- FastAPI middleware for per-endpoint latency tracking

## Minimal recipes

### Latency triage (local)
Run:
  pyinstrument -r html -o profile.html your_script.py
Then open profile.html and optimize the widest frames first.

### Deterministic overview (call counts + cumtime)
Run:
  python -m cProfile -o profile.prof your_script.py
Then:
  python -m pstats profile.prof
  # sort cumulative, show top entries

### Async endpoint profiling (FastAPI)
Profile a specific endpoint by wrapping the handler:
  from pyinstrument import Profiler

  async def my_endpoint():
      profiler = Profiler(async_mode="enabled")
      profiler.start()
      # ... your endpoint logic ...
      profiler.stop()
      profiler.print()

Or add middleware for broad coverage:
  @app.middleware("http")
  async def profile_middleware(request, call_next):
      profiler = Profiler(async_mode="enabled")
      profiler.start()
      response = await call_next(request)
      profiler.stop()
      # log or save profiler.output_html() for slow requests
      return response

Key: async_mode="enabled" lets pyinstrument track time spent in awaited coroutines
separately from active Python execution, so you can distinguish "waiting on DB/HTTP"
from "doing CPU work."

### Finding event loop blockers
If async endpoints are slow but CPU is low, a synchronous call may be blocking the loop.
Check for frames stuck in synchronous I/O (file reads, synchronous HTTP clients, etc.).
Fix by wrapping in run_in_executor or switching to an async library.

### Memory leak: tracemalloc diff
Use this pattern:
  - tracemalloc.start(N)
  - snapshot_before = take_snapshot()
  - run the suspicious operation
  - snapshot_after = take_snapshot()
  - compare_to(snapshot_before, "lineno")

### Memory leak / native allocations
Run:
  memray run -o memray.bin your_script.py
  memray flamegraph memray.bin -o memray.html
Open memray.html and look for the largest allocations and peaks.

## Tool availability

- **cProfile, pstats, tracemalloc**: Python stdlib, always available.
- **pyinstrument, memray**: Install into the project venv as needed
  (`pip install pyinstrument`, `pip install memray`).

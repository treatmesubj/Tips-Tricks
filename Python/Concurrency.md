# [Python Concurrency](http://masnun.rocks/2016/10/06/async-python-the-different-forms-of-concurrency/)

CPython has a Global Interpreter Lock (GIL) so you can't _truly_ multi-thread; only 1 thread can execute at a time, though you can resume/pause several threads and bounce between them.

- CPU Bound => `Multi Processing` (Parallel)
    - Local computation/math is slow; utilize several CPU Cores
    - Multiple Python Interpreters (for each process); high memory overhead
- I/O Bound, Max Allowed Number of Concurrent Tasks  => `Multi Threading`
    - External task (I/O) is slow (e.g. API request) and can only have 5 concurrent tasks (TCP/IP connections); run tasks concurrently
    - 1 Python Interpreter
- I/O Bound, Very Slow I/O, Many Connections => `Asyncio`
    - External tasks (I/O) are slow and complex; requires custom fine-tuned context-switching and execution

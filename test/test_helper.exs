
Application.ensure_started(:semaphore)
Application.ensure_started(:fast_global)

ExUnit.start()

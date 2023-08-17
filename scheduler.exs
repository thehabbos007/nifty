#!/usr/bin/env -S elixir --erl '+S 1:1' -S mix run --no-start -r
# ./scheduler.exs --
# ./scheduler.exs -- d

n = 10

sleep = 3000

pid = self()
run_dirty = System.argv() == ["d"]

spawn(fn ->
  if run_dirty do
    Nifty.Rifs.sleep_dirty(sleep)
  else
    Nifty.Rifs.sleep(sleep)
  end
end)

for i <- 1..n do
  spawn(fn ->
    send(pid, i)
  end)
end

for _ <- 1..n do
  receive do
    n ->
      IO.puts("Received #{n}")
  end
end

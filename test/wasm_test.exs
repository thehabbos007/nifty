defmodule NiftyWasmTest do
  use ExUnit.Case

  test "simple wasm 42" do
    bytes = File.read!("test/wasm_out.wasm")

    # starts a GenServer running a Wasm instance
    {:ok, pid} = Wasmex.start_link(%{bytes: bytes})
    {:ok, store} = Wasmex.store(pid)
    {:ok, memory} = Wasmex.memory(pid)

    body = "{\"hello\": \"world\"}"
    index = 0
    Wasmex.Memory.write_binary(store, memory, index, body)

    {:ok, out} = Wasmex.call_function(pid, "handle", [index, String.length(body)])
    IO.inspect(out)
    [pointer, len] = out
    IO.inspect({pointer, len})

    out_str = Wasmex.Memory.read_string(store, memory, pointer, len)

    assert out_str == "{\"status\": \"ok\"}"
  end
end

defmodule Nifty.Faas.HandlerSupervisor do
  use DynamicSupervisor

  @prefix FunctionPid

  alias Nifty.Faas.Db

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(route, bytes, config) do
    spec = {Wasmex, %{bytes: bytes}}

    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, spec)
    {:ok, store} = Wasmex.store(pid)
    {:ok, memory} = Wasmex.memory(pid)

    Db.insert(@prefix, route, %{pid: pid, config: config, store: store, memory: memory})
  end

  def list_routes() do
    Db.read_prefix(@prefix)
  end

  def find_route(route) do
    Db.get(@prefix, route)
  end

  def execute(%{pid: pid, store: store, memory: memory}, body) do
    body =
      case Jason.encode(body) do
        {:ok, json} ->
          json

        {:error, _} ->
          "{}"
      end

    index = 0
    Wasmex.Memory.write_binary(store, memory, index, body)
    IO.inspect(body)

    {:ok, [pointer, len]} = Wasmex.call_function(pid, "handle", [index, String.length(body)])

    Wasmex.Memory.read_string(store, memory, pointer, len)
  end
end

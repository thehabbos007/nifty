defmodule Nifty.Faas.Db do
  import Ex2ms

  def table_name() do
    Nifty.Faas.WasmHandlers
  end

  def init() do
    :ets.new(table_name(), [:ordered_set, :public, :named_table])
  end

  def insert(prefix, k, v) do
    :ets.insert(table_name(), {{prefix, k}, v})
  end

  def get(prefix, key) do
    selector =
      fun do
        {{^prefix, ^key}, v} ->
          v
      end

    case :ets.select(table_name(), selector) do
      [] -> nil
      [v] -> v
    end
  end

  def read_prefix(prefix) do
    selector =
      fun do
        {{^prefix, k}, v} ->
          {k, v}
      end

    :ets.select(table_name(), selector)
  end
end

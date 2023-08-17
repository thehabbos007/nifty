defmodule Nifty.Rifs do
  use Rustler, otp_app: :nifty, crate: :nifty_nifs

  @spec add(any, any) :: any
  def add(_a, _b), do: error()

  @doc """
  Sleep for a given number of milliseconds using a normal scheduler
  """
  def sleep(_duration_ms \\ 100), do: error()

  @spec sleep_dirty(any) :: any
  @doc """
  Sleep for a given number of milliseconds using a dirty scheduler
  """
  def sleep_dirty(_duration_ms \\ 100), do: error()

  @doc """
  Allocate a heap-based list in rust
  """
  def alloc_vec(), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end

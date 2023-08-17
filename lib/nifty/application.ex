defmodule Nifty.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # {Nifty.Worker, arg}
      {Bandit, plug: Nifty.Faas.Router, port: 4000},
      {Nifty.Faas.HandlerSupervisor, []}
    ]

    Nifty.Faas.Db.init()

    opts = [strategy: :one_for_one, name: Nifty.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

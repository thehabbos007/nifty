defmodule Nifty.Faas.Handler do
  defmodule Nifty.Faas.Handler.Config do
    defstruct verb: :string, path: :string

    @type t :: %__MODULE__{
            verb: :get | :post | :put | :delete,
            path: String.t()
          }
  end
end

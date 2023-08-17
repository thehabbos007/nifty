defmodule NiftyTest do
  use ExUnit.Case
  doctest Nifty

  test "greets the world" do
    assert Nifty.hello() == :world
  end
end

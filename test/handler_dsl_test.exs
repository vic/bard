defmodule Bard.Handler.DSLTest do
  use ExUnit.Case
  doctest Bard.Handler.DSL

  use Bard.Handler.DSL

  describe "Handler DSL" do

    test "expands each handler to a function that pipes the payload" do
      {:on, [bar: handler]} = on(bar: String.capitalize)
      assert "Bar" == handler.("bar")
    end

  end
end

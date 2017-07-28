defmodule BardBackendTest do
  use ExUnit.Case
  doctest BardBackend

  test "greets the world" do
    assert BardBackend.hello() == :world
  end
end

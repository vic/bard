defmodule BardTest do
  use ExUnit.Case
  doctest Bard


  describe "render" do
    import Bard.Render.R, only: [r: 1, r: 2]

    test "given tag but no props nor children" do
      assert {Div, []} == r(Div)
    end

    test "a tag with keyword properties" do
      assert {Button, [primary: true, theme: "dark"]} ==
        r(Button, primary: true, theme: "dark")
    end

    test "a tag with child as argument" do
      assert {Text, [children: ["Hello"]]} ==
        r(Text, "Hello")
    end

    test "a tag with single children as do option" do
      assert {Text, [children: ["Hello"]]} ==
        r(Text, do: "Hello")
    end

    test "a tag with many children" do
      assert (
        r(Div) do
          r(Input)
          r(Button)
        end ) ==
      {Div, [children: [{Input, []}, {Button, []}]]}
    end

    test "a tag skips non tag childs" do
      assert (
        r(Div) do
          r(Input)
          "skipped"
          r(Button)
        end) ==
      {Div, [children: [{Input, []}, {Button, []}]]}
    end

  end

end

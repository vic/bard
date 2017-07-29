defmodule BardTest do
  use ExUnit.Case
  doctest Bard


  describe "render" do
    import Bard.Render.R, only: [r: 1, r: 2]

    test "given tag but no props nor children" do
      assert {Div, []} == r(Div)
    end

    test "a tag with keyword properties" do
      assert {Button, [theme: "dark"]} ==
        r(Button, theme: "dark")
    end

    test "a tag with atom property set to true" do
      assert {Button, [primary: true]} ==
        r(Button, [:primary])
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

    test "a tag child can be any term" do
      assert (
        r(Div) do
          r(Input)
          "foo"
          r(Button)
        end) ==
      {Div, [children: [{Input, []}, "foo", {Button, []}]]}
    end

  end

end

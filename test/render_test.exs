defmodule Bard.RenderTest do
  use ExUnit.Case

  require Bard.TestComponents.World
  alias Bard.TestComponents.{BatMan, Hello, Text, Div}

  describe "param normalization" do
    test "converts into a map of sting keys" do
      expected = {Bat, %{"man" => "wayne", "children" => []}}
      assert expected == Bard.Render.render({BatMan, %{}}, nil)
    end
  end

  describe "child expansion" do
    test "expands known childs" do
      expected =  {Div, %{"children" => [
                           {Text, %{"children" => ["Hello"]}},
                           {Text, %{"children" => ["World"]}}
                       ]}}
      assert expected == Bard.Render.render({Hello, %{}}, nil)
    end
  end
end

defmodule Bard.RenderTest do
  use ExUnit.Case

  require Bard.TestComponents.World
  alias Bard.TestComponents.{BatMan, Hello, Text, Div, ClickHere, Button}

  def phx_send(context) do
    phx_ch_stub = Stubr.stub!([
      reply: fn _ref, _data -> :ok end
    ], call_info: true)

    context = Map.put(context, :phx_ch_stub, phx_ch_stub)
    {:ok, context}
  end

  setup_all :phx_send

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

  describe "handlers" do
    import Expat

    defpat button {Button, %{
                      "on" => [%{"click" => %{"fun" => fun}}],
                      "children" => children}}

    test "get replaced by function", %{phx_ch_stub: stub} do
      bard = %{socket_ref: 1, phx_channel: stub}
      assert button(fun: fun) = Bard.Render.render({ClickHere, %{}}, bard)
      assert Stubr.called_with?(stub, :reply, [bard.socket_ref, {:def, %{fun: fun}}])
    end
  end
end

defmodule Bard.TestComponents do

  alias __MODULE__.{Hello, World, Text, Div, Button}

  defmodule BatMan do
    def render(_props, _bard) do
      {Bat, man: "wayne"}
    end
  end

  defmodule Hello do
    def render(_props, _bard) do
      {Div, children: [
          {Text, children: ["Hello"]},
          {World, lang: "eng"}
        ]}
    end
  end

  defmodule World do
    def render(%{"lang" => "eng"}, _bard) do
      {Text, children: ["World"]}
    end

    def render(%{"lang" => "spa"}, _bard) do
      {Text, children: ["Mundo"]}
    end

    def render(_, _bard) do
      {Text, children: ["Bard"]}
    end
  end

  defmodule ClickHere do
    def render(_, bard) do
      {Button, [on: [click: fn true -> :clicked end]]}
    end
  end

end

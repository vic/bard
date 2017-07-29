defmodule Bard.TestComponents do

  alias __MODULE__.{Hello, World, Text}

  defmodule Hello do
    def render(_props = [], _bard) do
      {Div, children: [
          {Text, children: ["Hello"]},
          {World, english: true}
        ]}
    end
  end

  defmodule World do
    def render([english: true], _bard) do
      {Text, children: ["World"]}
    end

    def render([spanish: true], _bard) do
      {Text, children: ["Mundo"]}
    end
  end


end

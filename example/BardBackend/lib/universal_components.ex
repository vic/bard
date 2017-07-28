defmodule BardDemo.UniversalComponents do

  alias __MODULE__.{Hello, Text, Title}

  use Bard.Render

  defmodule Hello do
    def render(%{"to" => to}, _bard), do: hello(to)
    def render(_props, _bard), do: hello("Bard")

    defp hello(to) do
      r(Title, children: r(Text, children: "Hello #{to}!"))
    end
  end

end

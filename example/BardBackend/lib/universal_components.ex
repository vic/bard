defmodule BardDemo.UniversalComponents do

  alias __MODULE__.{Hello, Text, Title, Button}

  use Bard.Render

  defmodule Hello do
    def render(%{"to" => to}, _bard), do: hello(to)
    def render(_props, _bard), do: hello("Bard")

    defp hello(to) do
      r(Title, do: r(Text, do: "Hello #{to}!"))
    end
  end

  defmodule ClickHere do
    def render(props, bard) do
      r(Button,
        onClick: Bard.on(bard, &pressed/2)) do
        "Please click here"
      end
    end

    def pressed(payload, bard) do
      IO.inspect("PRESSED")
      Bard.eval(bard, "alert('Please dont!')")
    end
  end

end

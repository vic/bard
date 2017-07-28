defmodule BardDemo.UniversalComponents do

  alias __MODULE__.{Hello, Text, Title, Button}

  use Bard.Render

  defmodule Hello do
    def render(%{"to" => to}, _bard), do: hello(to)
    def render(_props, _bard), do: hello("Bard")

    defp hello(to) do
      r(Title, children: r(Text, children: "Hello #{to}!"))
    end
  end

  defmodule ClickHere do
    def render(props, bard) do
      Bard.eval(bard, "alert('bitch')")
      Bard.eval(bard, "console.log('FUCK ONE BITCH')")
      Bard.eval(bard, "console.log('FUCK TWO BITCH')")
      Bard.eval(bard, "console.log('FUCK TREE BITCH')")
      r(Button,
        # onClick: Bard.on(bard, &pressed/2),
        children: ["DONT CLICK HERE"])
    end

    def pressed(payload, bard) do
      IO.inspect("PRESSED")
      Bard.eval(bard, "alert('Please dont!')")
    end
  end

end

defmodule BardDemo.PortableComponents do

  use Bard.Components
  use Bard.Render

  alias __MODULE__, as: PC
  alias PC.{Hello, Text, Title}

  def component({Hello, props}, bard) do
    who = Map.get(props, "world", "from Bard")

    r(Title) do
      r(Text, "Hello #{who}!")
    end
  end

end

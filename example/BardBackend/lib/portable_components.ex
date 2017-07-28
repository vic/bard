defmodule BradDemo.PortableComponents do

  use Bard.Components
  use Bard.Render

  alias __MODULE__, as: PC
  alias PC.{Hello, Text}

  def component({Hello, props}, bard) do
    who = Map.get(props, "world", "Bard")
    r(Text, "Hello #{who}!")
  end
end

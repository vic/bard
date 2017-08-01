defmodule Bard.DSL do

  @doc false
  defmacro __using__(_) do
    quote do
      use Bard.Render.DSL
    end
  end

end

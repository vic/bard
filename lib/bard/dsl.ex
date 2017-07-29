defmodule Bard.DSL do

  @doc false
  defmacro __using__(_) do
    quote do
      use Bard.Render.DSL
      use Bard.Handler.DSL
    end
  end
end

defmodule Bard.Handler.DSL do

  @doc false
  def __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro on(event, handler) do
  end

end

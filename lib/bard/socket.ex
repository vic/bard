defmodule Bard.Socket do

  defmacro __using__(_) do
    quote do
      channel "bard:*", Bard.Channel
    end
  end

end

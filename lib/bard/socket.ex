defmodule Bard.Socket do

  @moduledoc """
  Enable Bard in your Phoenix application by
  adding the following line to your socket module:

     use Bard.Socket

  """

  defmacro __using__(_) do
    quote do
      channel "bard:*", Bard.Channel
    end
  end

end

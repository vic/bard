defmodule Bard.Send do

  alias Bard.Producer

  def send_next(msg, bard) do
    Producer.send_next(bard, msg)
  end

  def send_complete(msg, bard) do
    bard
    |> Producer.send_next(msg)
    |> Producer.send_complete
  end

end

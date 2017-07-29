defmodule Bard.Channel do

  @moduledoc false

  use Phoenix.Channel

  def join("bard:client", payload, socket) do
    {:ok, assign(socket, :bard_client, payload)}
  end

  def handle_in("bard:render", payload, socket) do
    %{"module" => module, "component" => component} = payload
    %{"props" => props}  = payload

    component = "#{module}.#{component}" |> String.to_existing_atom

    hash = :erlang.phash2({payload, socket})
    bard = %Bard{
      hash: hash,
      pid: self(),
      socket_ref: socket_ref(socket),
      endpoint: socket.endpoint,
      component: component
    }

    rendered = Bard.Render.render({component, props}, bard, &Bard.Render.into_map/1)
    Bard.reply(bard, :render, rendered)

    {:noreply, socket}
  end

end

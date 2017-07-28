defmodule Bard.Channel do
  use Phoenix.Channel

  def join("bard:client", payload, socket) do
    {:ok, assign(socket, :bard_client, payload)}
  end

  def handle_in("bard:render", payload, socket) do
    %{"module" => module, "component" => component} = payload
    %{"props" => props}  = payload

    component = "#{module}.#{component}" |> String.to_existing_atom

    bard = %{
      pid: self(),
      socket_ref: socket.ref,
      endpoint: socket.endpoint,
      client: socket.assigns.bard_client,
    }

    rendered = Bard.Render.render({component, props}, bard)
    {:reply, {:render, rendered}, socket}
  end

end

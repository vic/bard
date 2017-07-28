defmodule Bard.Channel do
  use Phoenix.Channel

  def join("bard:app:" <> _app, %{"module" => module}, socket) do
    module = String.to_existing_atom(module)
    {:ok, assign(socket, :bard_module, module)}
  end

  def handle_in("bard:start:" <> id, payload, socket) do
    bard = %{
      id: id,
      socket_ref: socket.ref,
      endpoint: socket.endpoint,
      module: socket.assigns.bard_module,
    }

    Bard.Producer.start(bard, payload)

    {:noreply, socket}
  end

  def handle_in("bard:stop:" <> id, _payload, socket) do
    Bard.Producer.stop(%{id: id})
    {:noreply, socket}
  end

  def handle_info({:send_next, bard, msg}, socket) do
    push(socket, "bard:next:" <> bard.id, msg)
    {:noreply, socket}
  end

  def handle_info({:send_complete, bard}, socket) do
    push(socket, "bard:complete:" <> bard.id, %{})
    {:noreply, socket}
  end

end

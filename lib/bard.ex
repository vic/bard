defmodule Bard do
  defstruct [:pid, :hash, :socket_ref, :endpoint, :component]

  def on(bard, fun, opts \\ []) when is_function(fun, 2) do
    hash = :erlang.phash2({bard, fun, opts})
    id = to_string(hash)
    reply(bard, :def, %{fun: id})
    %{fun: id}
  end

  def log(bard, msg) do
    reply(bard, :log, %{component: bard.component, msg: msg})
  end

  def eval(bard, js) do
    reply(bard, :eval, %{js: js})
  end

  def topic(bard) do
    "bard:component:#{bard.component}:#{bard.hash}"
  end

  def reply(bard, event, payload) do
    IO.inspect({:BARD_REPLY, event, payload})
    Phoenix.Channel.reply(bard.socket_ref, {event, payload})
    bard
  end
end

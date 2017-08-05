defmodule Bard do
  defstruct [:pid, :hash, :socket_ref, :endpoint, :component, :phx_channel]

  def defun(bard, fun) when is_function(fun, 1) do
    id = :erlang.phash2({bard, fun}) |> to_string
    reply(bard, :def, %{fun: id})
    id
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
    bard.phx_channel.reply(bard.socket_ref, {event, payload})
    bard
  end
end

defmodule Bard.Producer do

  def start(bard, payload) do
    register_master(bard)
    bard.module.start(bard.id, payload, bard)
    bard
  end

  def stop(bard) do
    bard = master(bard)
    bard.module.stop(bard.id, bard)
    unregister(bard)
    bard
  end

  def send_next(bard, msg) do
    send(master_pid(bard), {:send_next, bard, msg})
    bard
  end

  def send_complete(bard) do
    send(master_pid(bard), {:send_complete, bard})
    bard
  end

  defp master(bard) do
    [{_pid, {_id, bard}}] = Registry.match(__MODULE__, bard.id, {bard.id, :_})
    bard
  end

  defp master_pid(bard) do
    [{pid, _}] = Registry.match(__MODULE__, bard.id, {bard.id, :_})
    pid
  end

  defp register_master(bard) do
    Registry.register(__MODULE__, bard.id, {bard.id, bard})
  end

  defp unregister(bard) do
    IO.inspect({:UNREGISTER_ALL, bard.id})
    Registry.unregister(__MODULE__, bard.id)
    bard
  end

end

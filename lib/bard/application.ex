defmodule Bard.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      supervisor(Registry, [:duplicate, Bard.Producer])
    ]
    opts = [strategy: :one_for_one, name: __MODULE__.Supervisor]
    Supervisor.start_link(children, opts)
  end

end

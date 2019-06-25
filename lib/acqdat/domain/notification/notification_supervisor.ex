defmodule Acqdat.Domain.Notification.Supervisor do
  use Supervisor

  alias Acqdat.Domain.Notification.{Manager, Server}

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    children = [
      Server,
      Manager
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end

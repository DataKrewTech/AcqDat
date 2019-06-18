defmodule Acqdat.Domain.NotificationSupervisor do
  use Supervisor

  alias Acqdat.Domain.{NotificationManager, NotificationServer}

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    children = [
      NotificationServer,
      NotificationManager
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end

end

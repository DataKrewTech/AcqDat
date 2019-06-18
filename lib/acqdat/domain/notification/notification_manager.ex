defmodule Acqdat.Domain.NotificationManager do
  alias Acqdat.Domain.NotificationWorker
  def child_spec(_) do
    :poolboy.child_spec(
      __MODULE__,
      poolboy_config(),
      []
    )
  end

  def handle_notification(params) do
    :poolboy.transaction(__MODULE__,
      fn worker_pid ->
        NotificationWorker.handle_notificaton(worker_pid, params)
      end
    )
  end

  defp poolboy_config() do
    [
      name: {:local, __MODULE__},
      worker_module: NotificationWorker,
      size: 1000,
      max_overflow: 500
    ]
  end

end

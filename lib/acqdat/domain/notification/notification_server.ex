defmodule Acqdat.Domain.NotificationServer do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def enqueue() do

  end

  def init(_args) do
    {:ok, %{queue: :queue.new()}}
  end
end

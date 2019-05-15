defmodule AcqdatWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("data_point", %{"body" => body}, socket) do
    broadcast!(socket, "data_point", %{body: body})
    {:noreply, socket}
  end

end

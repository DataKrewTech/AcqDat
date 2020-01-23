defmodule AcqdatWeb.ProcessDataHistory.DryerController do
  use AcqdatWeb, :controller
  import Phoenix.View, only: [render_to_string: 3]
  plug(:put_layout, {AcqdatWeb.ProcessDataHistoryView, "process_data_history_layout.html"})

  def data_history(conn, _) do
    render(conn, "data_history.html")
  end
end

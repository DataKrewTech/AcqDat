defmodule AcqdatWeb.Dashboard.DryerController do
  use AcqdatWeb, :controller
  import Phoenix.View, only: [render_to_string: 3]
  plug(:put_layout, {AcqdatWeb.DashboardView, "dashboard_layout.html"})

  def index(conn, _) do
    render(conn, "index.html")
  end
end

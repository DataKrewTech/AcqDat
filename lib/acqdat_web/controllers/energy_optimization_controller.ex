defmodule AcqdatWeb.EnergyOptimizationController do
  use AcqdatWeb, :controller
  import Phoenix.View, only: [render_to_string: 3]

  def index(conn, _) do
    render(conn, "index.html")
  end
end

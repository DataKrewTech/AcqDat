defmodule AcqdatWeb.ProcessDataHistoryView do
  use AcqdatWeb, :view
  import AcqdatWeb.LayoutView, only: [render_layout: 3]

  def active_link(conn, key) do
    regex = Regex.compile!(key)
    if  Regex.match?(regex, conn.request_path) do
      "active"
    else
      ""
    end
  end
end

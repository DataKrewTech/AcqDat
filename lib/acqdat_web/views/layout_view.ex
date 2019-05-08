defmodule AcqdatWeb.LayoutView do
  use AcqdatWeb, :view
  alias AcqdatWeb.Guardian

  def current_user(conn) do
    user = conn.assigns.current_user
    user.first_name
  end

end

defmodule AcqdatWeb.DeviceView do
  use AcqdatWeb, :view

  def render("success.json", %{message: message}) do
    %{status: message}
  end
end

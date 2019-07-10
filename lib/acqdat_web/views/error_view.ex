defmodule AcqdatWeb.ErrorView do
  use AcqdatWeb, :view


  def render("404.json-api", _assigns) do
    %{
      title: "404 Not Found",
      detail: "404 Not Found",
      status: "404"
    }
    |> JaSerializer.ErrorSerializer.format
  end

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end

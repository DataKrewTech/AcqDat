defmodule AcqdatWeb.API.ToolManagementView do
  use AcqdatWeb, :view

  @status_verified "verified"
  @status_unidentitified "unidentified"

  def render("employee_verified.json", %{status: :ok, data: employee}) do
    %{
      status: @status_verified,
      employee: %{
        name: employee.name
      }
    }
  end
  def render("employee_verified.json", %{status: :error, data: message}) do
    %{
      status: @status_unidentitified,
      message: message
    }
  end

  def render("transaction_success.json", %{data: data}) do
    %{data: data, status: "success"}
  end

  def render("transaction_error.json", %{errors: errors}) do
    %{errors: errors, status: "error"}
  end
end

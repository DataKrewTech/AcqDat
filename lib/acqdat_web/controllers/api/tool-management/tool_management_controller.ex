defmodule AcqdatWeb.API.ToolManagementController do
  use AcqdatWeb, :controller
  use Params
  import AcqdatWeb.Helpers
  defparams(
    tool_transaction_params(%{
      user_uuid!: :string,
      tool_box_uuid!: :string,
      tool_ids!: [:string],
      transaction: :string
    })
  )

  alias Acqdat.Context.ToolManagement

  def verify_employee(conn, params) do
    %{"user_uuid" => uuid} = params
    {status, data} = ToolManagement.verify_employee(%{uuid: uuid})
    render(conn, "employee_verified.json", status: status, data: data)
  end

  def tool_transaction(conn, params) do
    changeset = tool_transaction_params(params)

    with {:extract, {:ok, tool_params}} <- {:extract, extract_changeset_data(changeset)},
      {:add_data, {:ok, data}} <- {:add_data,
        ToolManagement.tool_transaction(Map.from_struct(tool_params))} do
      render(conn, "transaction_success.json", data: data)
    else
      {:extract, {:error, changeset}} ->
        errors = extract_changeset_errors(changeset)
        render(conn, "transaction_error.json", errors: errors)
      {:add_data, {:error, errors}} ->
        render(conn, "transaction_error.json", errors: errors)
    end
  end
end

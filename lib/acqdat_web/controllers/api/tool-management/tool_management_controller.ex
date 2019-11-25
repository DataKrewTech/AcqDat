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

  defparams(
    verify_tool(%{
      tool_box_uuid!: :string,
      tool_uuid!: :string
    })
  )

  defparams(
    verify_employee_status(%{
      employee_uuid!: :string
    })
  )

  defparams(
    verify_tool_box_status(%{
      tool_box_uuid!: :string
    })
  )

  alias Acqdat.Context.ToolManagement

  def verify_employee(conn, params) do
    %{"user_uuid" => uuid} = params
    {status, data} = ToolManagement.verify_employee(%{uuid: uuid})
    render(conn, "employee_verified.json", status: status, data: data)
  end

  def employee_tool_issue_status(conn, params) do
    changeset = verify_employee_status(params)

    with {:extract, {:ok, data}} <- {:extract, extract_changeset_data(changeset)},
    {:ok, tools} <- ToolManagement.employee_transaction_status(data.employee_uuid)
    do
      render(conn, "tools.json", tools: tools)
    else
      {:extract, {:error, changeset}} ->
        errors = extract_changeset_errors(changeset)
        conn
        |> put_status(400)
        |> render("transaction_error.json", errors: errors)
      {:error, errors} ->
        conn
        |> put_status(404)
        |> render("error.json", errors: errors)
    end
  end

  def tool_box_status(conn, params) do
    changeset = verify_tool_box_status(params)

    with {:extract, {:ok, data}} <- {:extract, extract_changeset_data(changeset)},
      {:ok, tools} <- ToolManagement.tool_box_status(data.tool_box_uuid)
    do
      render(conn, "tools.json", tools: tools)
    else
    {:extract, {:error, changeset}} ->
      errors = extract_changeset_errors(changeset)
      conn
      |> put_status(400)
      |> render("transaction_error.json", errors: errors)
    {:error, errors} ->
      conn
      |> put_status(401)
      |> render("error.json", errors: errors)
    end
  end

  def verify_tool(conn, params) do
    changeset = verify_tool(params)

    with {:extract, {:ok, tool_params}} <- {:extract, extract_changeset_data(changeset)},
      {:tool, {:ok, tool}} <- {:tool, ToolManagement.verify_tool(tool_params)}
    do
      render(conn, "tool.json", tool: tool)
    else
      {:extract, {:error, changeset}} ->
        errors = extract_changeset_errors(changeset)
        conn
        |> put_status(400)
        |> render("transaction_error.json", errors: errors)
      {:tool, {:error, errors}} ->
        conn
        |> put_status(401)
        |> render("error.json", errors: errors)
    end
  end

  def list_employees(conn, _params) do
    employees = ToolManagement.employees(nil)
    render(conn, "employees.json", employees: employees)
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
        conn
        |> put_status(400)
        |> render("transaction_error.json", errors: errors)
      {:add_data, {:error, errors}} ->
        conn
        |> put_status(400)
        |> render("transaction_error.json", errors: errors)
    end
  end
end

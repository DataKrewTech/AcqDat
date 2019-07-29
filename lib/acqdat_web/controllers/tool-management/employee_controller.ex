defmodule AcqdatWeb.ToolManagement.EmployeeController do
  use AcqdatWeb, :controller
  alias Acqdat.Model.ToolManagement.Employee
  alias Acqdat.Schema.ToolManagement.Employee, as: EmployeeSchema

  plug(:put_layout, {AcqdatWeb.ToolManagementView, "tool_management_layout.html"})

  def index(conn, _params) do
    employees = Employee.get_all()
    render(conn, "index.html", employees: employees)
  end

  def show(conn, %{"id" => id}) do

  end

  def new(conn, _params) do
    changeset = EmployeeSchema.create_changeset(%EmployeeSchema{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"employee" => params}) do
    with {:ok, _employee} <- Employee.create(params) do
      conn
      |> put_flash(:info, "Record Added!")
      |> redirect(to: Routes.employee_path(conn, :index))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "There were some errors!")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, employee} <- id |> String.to_integer() |> Employee.get() do
      changeset = EmployeeSchema.update_changeset(employee, %{})
      render(conn, "edit.html", changeset: changeset, employee: employee)
    else
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.employee_path(conn, :index))
    end
  end

  def update(conn, %{"employee" => params, "id" => id}) do
    {:ok, employee} = id |> String.to_integer() |> Employee.get()

    with {:ok, _employee} <- Employee.update(employee, params) do
      conn
      |> put_flash(:info, "Record Updated")
      |> redirect(to: Routes.employee_path(conn, :index))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error,  "There are some errors!")
        |> render("edit.html", changeset: changeset, employee: employee)
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> Employee.delete()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Record removed")
        |> redirect(to: Routes.employee_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Some error occured!")
        |> redirect(to: Routes.employee_path(conn, :index))
    end
  end
end

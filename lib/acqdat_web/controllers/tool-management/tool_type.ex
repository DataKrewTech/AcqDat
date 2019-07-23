defmodule AcqdatWeb.ToolManagement.ToolTypeController do
  use AcqdatWeb, :controller
  alias Acqdat.Model.ToolManagement.ToolType
  alias Acqdat.Schema.ToolManagement.ToolType, as: ToolTypeSchema

  plug(:put_layout, {AcqdatWeb.ToolManagementView, "tool_management_layout.html"})

  def index(conn, _params) do
    tool_types = ToolType.get_all()
    render(conn, "index.html", tool_types: tool_types)
  end

  def new(conn, _params) do
    changeset = ToolTypeSchema.changeset(%ToolTypeSchema{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tool_type" => params}) do
    with {:ok, _tool_type} <- ToolType.create(params) do
      conn
      |> put_flash(:info, "Record Added!")
      |> redirect(to: Routes.tool_type_path(conn, :index))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "There were some errors!")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, tool_type} <- id |> String.to_integer() |> ToolType.get() do
      changeset = ToolTypeSchema.changeset(tool_type, %{})
      render(conn, "edit.html", changeset: changeset, tool_type: tool_type)
    else
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(Routes.tool_type_path(conn, :index))
    end
  end

  def update(conn, %{"tool_type" => params, "id" => id}) do
    {:ok, tool_type} = id |> String.to_integer() |> ToolType.get()

    with {:ok, _tool_type} <- ToolType.update(tool_type, params) do
      conn
      |> put_flash(:info, "Record Updated")
      |> redirect(to: Routes.tool_type_path(conn, :index))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error,  "There are some errors!")
        |> render("edit.html", changeset: changeset, tool_type: tool_type)
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> ToolType.delete()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Record removed")
        |> redirect(to: Routes.tool_type_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Some error occured!")
        |> redirect(to: Routes.tool_type_path(conn, :index))
    end
  end
end

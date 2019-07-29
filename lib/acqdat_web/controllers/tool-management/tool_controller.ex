defmodule AcqdatWeb.ToolManagement.ToolController do
  use AcqdatWeb, :controller
  alias Acqdat.Model.ToolManagement.Tool
  alias Acqdat.Schema.ToolManagement.Tool, as: ToolSchema

  plug(:put_layout, {AcqdatWeb.ToolManagementView, "tool_management_layout.html"})

  def show(conn, %{"id" => id}) do

  end

  def new(conn, %{"tool_box_id" => tool_box_id}) do
    changeset = ToolSchema.create_changeset(%ToolSchema{}, %{})
    render(conn, "new.html", changeset: changeset, tool_box_id: String.to_integer(tool_box_id))
  end

  def create(conn, %{"tool_box_id" => tool_box_id, "tool" => params}) do
    tool_box_id = String.to_integer(tool_box_id)

    with {:ok, _tool} <- Tool.create(params) do
      conn
      |> put_flash(:info, "Record Added!")
      |> redirect(to: Routes.tool_box_path(conn, :show, tool_box_id))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "There were some errors!")
        |> render("new.html", changeset: changeset, tool_box_id: tool_box_id)
    end
  end

  def edit(conn, %{"tool_box_id" => tool_box_id, "id" => id}) do
    tool_box_id = String.to_integer(tool_box_id)

    with {:ok, tool} <- id |> String.to_integer() |> Tool.get() do
      changeset = ToolSchema.update_changeset(tool, %{})
      render(conn, "edit.html", changeset: changeset, tool: tool,
        tool_box_id: tool_box_id)
    else
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.tool_box_path(conn, :show, tool_box_id))
    end
  end

  def update(conn, %{"tool_box_id" => tool_box_id, "tool" => params, "id" => id}) do
    {:ok, tool} = id |> String.to_integer() |> Tool.get()
    tool_box_id = String.to_integer(tool_box_id)

    with {:ok, _tool} <- Tool.update(tool, params) do
      conn
      |> put_flash(:info, "Record Updated")
      |> redirect(to: Routes.tool_box_path(conn, :show, tool_box_id))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error,  "There are some errors!")
        |> render("edit.html", changeset: changeset, tool: tool, tool_box_id: tool_box_id)
    end
  end

  def delete(conn, %{"id" => id, "tool_box_id" => tool_box_id}) do
    id
    |> String.to_integer()
    |> Tool.delete()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Record removed")
        |> redirect(to: Routes.tool_box_path(conn, :show, tool_box_id))

      {:error, _} ->
        conn
        |> put_flash(:error, "Some error occured!")
        |> redirect(to: Routes.tool_box_path(conn, :show, tool_box_id))
    end
  end
end

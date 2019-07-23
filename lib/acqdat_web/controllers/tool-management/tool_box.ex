defmodule AcqdatWeb.ToolManagement.ToolBoxController do
  use AcqdatWeb, :controller
  alias Acqdat.Model.ToolManagement.ToolBox
  alias Acqdat.Schema.ToolManagement.ToolBox, as: ToolBoxSchema

  plug(:put_layout, {AcqdatWeb.ToolManagementView, "tool_management_layout.html"})

  def index(conn, _params) do
    tool_boxes = ToolBox.get_all()
    render(conn, "index.html", tool_boxes: tool_boxes)
  end

  def show(conn, %{"id" => id}) do

  end

  def new(conn, _params) do
    changeset = ToolBoxSchema.create_changeset(%ToolBoxSchema{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tool_box" => params}) do
    with {:ok, _tool_box} <- ToolBox.create(params) do
      conn
      |> put_flash(:info, "Record Added!")
      |> redirect(to: Routes.tool_box_path(conn, :index))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "There were some errors!")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, tool_box} <- id |> String.to_integer() |> ToolBox.get() do
      changeset = ToolBoxSchema.update_changeset(tool_box, %{})
      render(conn, "edit.html", changeset: changeset, tool_box: tool_box)
    else
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(Routes.tool_box_path(conn, :index))
    end
  end

  def update(conn, %{"tool_box" => params, "id" => id}) do
    {:ok, tool_box} = id |> String.to_integer() |> ToolBox.get()

    with {:ok, _tool_box} <- ToolBox.update(tool_box, params) do
      conn
      |> put_flash(:info, "Record Updated")
      |> redirect(to: Routes.tool_box_path(conn, :index))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error,  "There are some errors!")
        |> render("edit.html", changeset: changeset, tool_box: tool_box)
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> String.to_integer()
    |> ToolBox.delete()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Record removed")
        |> redirect(to: Routes.tool_box_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Some error occured!")
        |> redirect(to: Routes.tool_box_path(conn, :index))
    end
  end
end

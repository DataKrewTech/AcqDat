defmodule AcqdatWeb.DataTraceController do
  use AcqdatWeb, :controller

  @index_url "https://innovfest19-bl.herokuapp.com/blocklist"
  @detail_url "https://innovfest19-bl.herokuapp.com/blockinfo/"

  def index(conn, _args) do
    blocks = get_and_parse_blocks()
    render(conn, "index.html", blocks: blocks)
  end

  def show(conn, %{"id" => id}) do
    block = block_details(id)
    render(conn, "show.html", block: block)
  end

  defp get_and_parse_blocks() do
    result = HTTPoison.get!(@index_url)
    Jason.decode!(result.body)
  end

  defp block_details(id) do
    url = @detail_url <> id
    result = HTTPoison.get!(url)
    Jason.decode!(result.body)
  end
end

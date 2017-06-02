defmodule Wo.SearchController do
  use Wo.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html", sermons: [], ranks: [])
  end

  def search(conn, %{"search" => %{"search_term" => search_term}}) do
    {:ok, sermon_results} = Ecto.Adapters.SQL.query(Repo, "select document_table, document_id, ts_rank(content, keywords) as rank from search_documents, plainto_tsquery('english', $1) keywords where (content @@ keywords and document_table = 'sermons')", [search_term])

    ranks = Enum.reduce(sermon_results.rows, [], fn(r, ranks) -> ranks ++ [Enum.at(r, 2)] end)
    sermons = Enum.reduce(sermon_results.rows, [], fn(r, sermons) -> sermons ++ [Repo.get_by(Wo.Sermon, id: Enum.at(r, 1))] end)

    render(conn, "index.html", sermons: sermons, ranks: ranks)
  end
end

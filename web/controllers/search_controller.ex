defmodule Wo.SearchController do
  use Wo.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html", sermons: [], ranks: [])
  end

  def search(conn, %{"search" => %{"search_term" => search_term}}) do
    {:ok, sermon_results} = sql("select document_table, document_id, ts_rank(content, keywords) as rank from search_documents, plainto_tsquery('english', $1) keywords where content @@ keywords", [search_term])

    ranks = Enum.reduce(sermon_results.rows, [], fn(r, ranks) -> ranks ++ [Enum.at(r, 2)] end)
    sermons = Enum.reduce(sermon_results.rows, [], fn(r, sermons) ->
      IO.puts "select ts_headline(title, to_tsquery($1)) as title, ts_headline(description, to_tsquery($1)) as description, ts_headline(passages, to_tsquery($1)) as passage from " <> Enum.at(r, 0) <> " where id = $2"
      {:ok, values} = sql("select ts_headline(title, to_tsquery($1)) as title, ts_headline(description, to_tsquery($1)) as description, ts_headline(passages, to_tsquery($1)) as passage from " <> Enum.at(r, 0) <> " where id = $2", [search_term, Enum.at(r, 1)])
      sermons ++ [values]
    end)

    render(conn, "index.html", sermons: sermons, ranks: ranks)
  end

  defp sql(raw, params) do
    Ecto.Adapters.SQL.query(Repo, raw, params)
  end
end

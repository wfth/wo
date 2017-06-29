defmodule Wo.SearchController do
  use Wo.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html", results: [])
  end

  def search(conn, %{"search" => %{"search_term" => search_term}}) do
    {:ok, search_results} = sql("select document_table,
                                        document_id,
                                        ts_rank(content, keywords) as rank
                                        from search_documents, plainto_tsquery('english', $1) keywords
                                        where content @@ keywords", [search_term])

    ranks = Enum.reduce(search_results.rows, [], fn(r, ranks) -> ranks ++ [Enum.at(r, 2)] end)
    results = Enum.reduce(search_results.rows, [], fn(r, results) ->
      {:ok, values} = sql("select ts_headline(title, to_tsquery($1)) as title,
                                  ts_headline(description, to_tsquery($1)) as description,
                                  ts_headline(passages, to_tsquery($1)) as passage"
                                  <> (if Enum.at(r, 0) == "sermons", do: ", audio_url ", else: " ") <> "from "
                                  <> Enum.at(r, 0)
                                  <> " where id = $2",
                                  [search_term, Enum.at(r, 1)])
      results ++ [values]
    end)

    ranked_results_list = ranks
                          |> Enum.with_index
                          |> Enum.reduce([], fn({rank, i}, acc) ->
                               acc ++ [{rank, Enum.at(results, i)}]
                             end)
                          |> Enum.sort(fn({rank1, _result1}, {rank2, _result2}) ->
                               rank1 >= rank2
                             end)

    render(conn, "index.html", results: ranked_results_list)
  end

  defp sql(raw, params) do
    Ecto.Adapters.SQL.query(Repo, raw, params)
  end
end

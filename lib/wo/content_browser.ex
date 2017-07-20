defmodule Wo.ContentBrowser do
  import Ecto.Query, warn: false
  alias Wo.Repo

  alias Wo.ContentBrowser.SermonSeries

  def list_sermon_series, do: Repo.all(SermonSeries)
  def get_sermon_series!(id), do: Repo.get!(SermonSeries, id)


  alias Wo.ContentBrowser.Sermon

  def list_sermons, do: Repo.all(Sermon)
  def get_sermon!(id), do: Repo.get!(Sermon, id)
end

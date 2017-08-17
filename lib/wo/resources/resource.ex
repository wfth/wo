defmodule Wo.Resource do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Wo.Repo

  alias Wo.Resource.SermonSeries

  def list_sermon_series, do: Repo.all(SermonSeries)
  def get_sermon_series!(id), do: Repo.get!(SermonSeries, id)

  def create_sermon_series(attrs \\ %{}) do
    %SermonSeries{}
    |> SermonSeries.changeset(attrs)
    |> Repo.insert()
  end

  def update_sermon_series(%SermonSeries{} = sermon_series, attrs) do
    sermon_series
    |> SermonSeries.changeset(attrs)
    |> Repo.update()
  end

  def delete_sermon_series(%SermonSeries{} = sermon_series) do
    Repo.delete(sermon_series)
  end

  def change_sermon_series(%SermonSeries{} = sermon_series) do
    SermonSeries.changeset(sermon_series, %{})
  end

  alias Wo.Resource.Sermon

  def list_sermons(sermon_series_id, preload: true) do
    list_sermons(sermon_series_id) |> Repo.preload(:sermon_series)
  end
  def list_sermons(sermon_series_id) do
    Repo.all(from s in Sermon, where: s.sermon_series_id == ^sermon_series_id)
  end

  def get_sermon!(id, preload: true), do: get_sermon!(id) |> Repo.preload(:sermon_series)
  def get_sermon!(id), do: Repo.get!(Sermon, id)

  def create_sermon(attrs \\ %{},
                    %SermonSeries{} = sermon_series \\ %SermonSeries{},
                    %Sermon{} = sermon \\ %Sermon{}) do
    sermon
    |> Sermon.changeset(attrs)
    |> put_assoc(:sermon_series, sermon_series)
    |> Repo.insert()
  end

  def update_sermon(%Sermon{} = sermon, attrs) do
    sermon
    |> Sermon.changeset(attrs)
    |> Repo.update()
  end

  def delete_sermon(%Sermon{} = sermon) do
    Repo.delete(sermon)
  end

  def change_sermon(%Sermon{} = sermon) do
    Sermon.changeset(sermon, %{})
  end
end

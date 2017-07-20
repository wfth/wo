defmodule Wo.ContentEditor do
  import Ecto.Query, warn: false
  alias Wo.Repo

  alias Wo.ContentEditor.SermonSeries

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

  def change_sermon_series(%SermonSeries{} = sermon_series, %{} = attrs) do
    SermonSeries.changeset(sermon_series, attrs)
  end


  alias Wo.ContentEditor.Sermon

  def list_sermons do
    Repo.all(Sermon)
  end

  def get_sermon!(id), do: Repo.get!(Sermon, id)

  def create_sermon(attrs \\ %{}) do
    %Sermon{}
    |> Sermon.changeset(attrs)
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

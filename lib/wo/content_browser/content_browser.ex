defmodule Wo.ContentBrowser do
  @moduledoc """
  The boundary for the ContentBrowser system.
  """

  import Ecto.Query, warn: false
  alias Wo.Repo

  alias Wo.ContentBrowser.SermonSeries

  @doc """
  Returns the list of sermon_series.

  ## Examples

      iex> list_sermon_series()
      [%SermonSeries{}, ...]

  """
  def list_sermon_series do
    Repo.all(SermonSeries)
  end

  @doc """
  Gets a single sermon_series.

  Raises `Ecto.NoResultsError` if the Sermon series does not exist.

  ## Examples

      iex> get_sermon_series!(123)
      %SermonSeries{}

      iex> get_sermon_series!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sermon_series!(id), do: Repo.get!(SermonSeries, id)

  @doc """
  Creates a sermon_series.

  ## Examples

      iex> create_sermon_series(%{field: value})
      {:ok, %SermonSeries{}}

      iex> create_sermon_series(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sermon_series(attrs \\ %{}) do
    %SermonSeries{}
    |> SermonSeries.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sermon_series.

  ## Examples

      iex> update_sermon_series(sermon_series, %{field: new_value})
      {:ok, %SermonSeries{}}

      iex> update_sermon_series(sermon_series, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sermon_series(%SermonSeries{} = sermon_series, attrs) do
    sermon_series
    |> SermonSeries.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SermonSeries.

  ## Examples

      iex> delete_sermon_series(sermon_series)
      {:ok, %SermonSeries{}}

      iex> delete_sermon_series(sermon_series)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sermon_series(%SermonSeries{} = sermon_series) do
    Repo.delete(sermon_series)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sermon_series changes.

  ## Examples

      iex> change_sermon_series(sermon_series)
      %Ecto.Changeset{source: %SermonSeries{}}

  """
  def change_sermon_series(%SermonSeries{} = sermon_series) do
    SermonSeries.changeset(sermon_series, %{})
  end

  alias Wo.ContentBrowser.Sermon

  @doc """
  Returns the list of sermons.

  ## Examples

      iex> list_sermons()
      [%Sermon{}, ...]

  """
  def list_sermons do
    Repo.all(Sermon)
  end

  @doc """
  Gets a single sermon.

  Raises `Ecto.NoResultsError` if the Sermon does not exist.

  ## Examples

      iex> get_sermon!(123)
      %Sermon{}

      iex> get_sermon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sermon!(id), do: Repo.get!(Sermon, id)

  @doc """
  Creates a sermon.

  ## Examples

      iex> create_sermon(%{field: value})
      {:ok, %Sermon{}}

      iex> create_sermon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sermon(attrs \\ %{}) do
    %Sermon{}
    |> Sermon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sermon.

  ## Examples

      iex> update_sermon(sermon, %{field: new_value})
      {:ok, %Sermon{}}

      iex> update_sermon(sermon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sermon(%Sermon{} = sermon, attrs) do
    sermon
    |> Sermon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sermon.

  ## Examples

      iex> delete_sermon(sermon)
      {:ok, %Sermon{}}

      iex> delete_sermon(sermon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sermon(%Sermon{} = sermon) do
    Repo.delete(sermon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sermon changes.

  ## Examples

      iex> change_sermon(sermon)
      %Ecto.Changeset{source: %Sermon{}}

  """
  def change_sermon(%Sermon{} = sermon) do
    Sermon.changeset(sermon, %{})
  end

  alias Wo.ContentBrowser.SearchDocument
end

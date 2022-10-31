defmodule Streamy.Folders.FolderRepo do
  alias Streamy.Folders.Folder
  alias Streamy.Repo

  def get_all() do
    Folder |> Repo.all()
  end

  @spec insert(Ecto.Changeset.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert(changeset) do
    Repo.insert(changeset)
  end

  def update(folder) do
    Repo.update!(folder)
  end

  def get_by_id(id) do
    Folder |> Repo.get!(id)
  end
end

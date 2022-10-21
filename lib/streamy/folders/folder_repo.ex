defmodule Streamy.Folders.FolderRepo do
  alias Streamy.Folders.Folder
  alias Streamy.Repo

  def get_all() do
    Folder |> Repo.all()
  end

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

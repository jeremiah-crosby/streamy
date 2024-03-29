defmodule Streamy.Folders.FolderRepoEcto do
  @behaviour Streamy.Folders.FolderRepo

  alias Streamy.Folders.Folder
  alias Streamy.Repo
  alias Streamy.Folders.FolderRepo

  @impl FolderRepo
  def get_all() do
    Folder |> Repo.all()
  end

  @impl FolderRepo
  def insert(changeset) do
    Repo.insert(changeset)
  end

  @impl FolderRepo
  def update(folder) do
    Repo.update!(folder)
  end

  @impl FolderRepo
  def get_by_id(id) do
    Folder |> Repo.get!(id)
  end

  @impl FolderRepo
  def delete(id) do
    try do
      folder = Folder |> Repo.get!(id)
      case Repo.delete(folder) do
        {:ok, _} -> :ok
        {:error, err} -> {:error, err}
      end
    rescue
      e in RuntimeError -> {:error, e.message}
    end
  end
end

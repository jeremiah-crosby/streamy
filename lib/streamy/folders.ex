defmodule Streamy.Folders do
  alias Streamy.Folders.Folder
  alias Streamy.Folders.FolderRepo

  def create_folder(attrs) do
    %Streamy.Folders.Folder{}
    |> Folder.changeset(attrs)
    |> FolderRepo.insert()
  end

  def create_folder_from_path(path) do
    %Streamy.Folders.Folder{}
    |> Folder.changeset(%{name: Path.basename(path), physical_path: path})
    |> FolderRepo.insert()
  end

  def get_all() do
    FolderRepo.get_all()
  end

  def get_by_id(id) do
    FolderRepo.get_by_id(id)
  end
end

defmodule Streamy.Folders do
  alias Streamy.Folders.Folder
  alias Streamy.Folders.FolderRepo

  def create_folder(attrs) do
    %Streamy.Folders.Folder{}
    |> Folder.changeset(attrs)
    |> FolderRepo.insert()
  end

  def get_all() do
    FolderRepo.get_all()
  end
end

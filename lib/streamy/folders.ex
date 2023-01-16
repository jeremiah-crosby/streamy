defmodule Streamy.Folders do
  alias Streamy.Folders.Folder

  def create_folder(attrs) do
    %Streamy.Folders.Folder{}
    |> Folder.changeset(attrs)
    |> repo().insert()
  end

  @spec create_folder_from_path(String.t()) ::
          {:ok, %Streamy.Folders.Folder{}} | {:error, String.t()}
  def create_folder_from_path(path) do
    changeSet =
      %Streamy.Folders.Folder{}
      |> Folder.changeset(%{name: Path.basename(path), physical_path: path})

    case repo().insert(changeSet) do
      {:ok, folder} ->
        {:ok, folder}

      {:error, changeset} ->
        {:error, Enum.reduce(changeset.errors, "", fn err, errStr -> errStr ++ err ++ "\n" end)}
    end
  end

  def get_all() do
    repo().get_all()
  end

  def get_by_id(id) do
    repo().get_by_id(id)
  end

  def delete(id) do
    repo().delete(id)
  end

  defp repo do
    Application.get_env(:streamy, __MODULE__)[:repo_impl]
  end
end

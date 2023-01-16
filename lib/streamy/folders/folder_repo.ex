defmodule Streamy.Folders.FolderRepo do
  alias Streamy.Folders.Folder

  @callback get_all() :: [%Folder{}]

  @callback insert(Ecto.Changeset.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @callback update(Ecto.Changeset.t()) :: Ecto.Schema.t()

  @callback get_by_id(Ecto.UUID.t()) :: %Folder{}

  @callback delete(Ecto.UUID.t()) :: :ok | {:error, term()}
end

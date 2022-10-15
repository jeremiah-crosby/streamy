defmodule Streamy.Folders.Folder do
  use Ecto.Schema
  import Ecto.Changeset

  alias Streamy.Folders.FolderRepo

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "folders" do
    field :name, :string
    field :physical_path, :string

    has_many :videos, Streamy.Videos.Video

    timestamps()
  end

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, [:name, :physical_path])
    |> validate_required([:name, :physical_path])
  end

  def create_folder(attrs) do
    %Streamy.Folders.Folder{}
    |> changeset(attrs)
    |> FolderRepo.insert()
  end
end

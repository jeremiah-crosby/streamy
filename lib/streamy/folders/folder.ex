defmodule Streamy.Folders.Folder do
  use Ecto.Schema
  import Ecto.Changeset

  alias Streamy.Repo

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "folders" do
    field :name, :string
    field :physical_path, :string

    timestamps()
  end

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, [:name, :physical_path])
    |> validate_required([:name, :physical_path])
  end
end

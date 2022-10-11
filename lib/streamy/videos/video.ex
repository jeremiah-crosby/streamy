defmodule Streamy.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "videos" do
    field :location, :string
    field :title, :string
    field :folder_id, :binary

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title, :location])
    |> validate_required([:title, :location])
  end
end

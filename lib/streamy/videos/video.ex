defmodule Streamy.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :location, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title, :location])
    |> validate_required([:title, :location])
  end
end

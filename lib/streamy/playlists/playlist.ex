defmodule Streamy.Playlists.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playlists" do
    field :name, :string
    many_to_many :videos, Streamy.Videos.Video,
      join_through: Streamy.Playlists.PlaylistItem

    timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

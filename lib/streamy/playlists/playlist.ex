defmodule Streamy.Playlists.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "playlists" do
    field :name, :string
    many_to_many :videos, Streamy.Videos.Video,
      join_through: Streamy.Playlists.PlaylistItem,
      join_keys: [playlist_id: :id, video_id: :id]

    timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

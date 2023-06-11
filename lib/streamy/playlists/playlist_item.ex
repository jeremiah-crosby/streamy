defmodule Streamy.Playlists.PlaylistItem do
  use Ecto.Schema
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "playlist_items" do
    belongs_to :playlist, Streamy.Playlists.Playlist
    belongs_to :video, Streamy.Videos.Video

    timestamps()
  end
end

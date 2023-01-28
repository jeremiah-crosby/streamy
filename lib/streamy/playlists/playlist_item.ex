defmodule Streamy.Playlists.PlaylistItem do
  use Ecto.Schema

  schema "playlist_items" do
    belongs_to :playlists, Streamy.Playlists.Playlist
    belongs_to :videos, Streamy.Videos.Video

    timestamps()
  end
end

defmodule Streamy.Playlists.PlaylistRepo do
  alias Streamy.Playlists.Playlist

  @type id :: Ecto.UUID.t()

  @callback get_all() :: [%Playlist{}]
  @callback create_playlist_item(id, id) :: %Streamy.Playlists.PlaylistItem{}
end

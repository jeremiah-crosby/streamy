defmodule Streamy.Playlists.PlaylistRepo do
  alias Streamy.Playlists.Playlist

  @callback get_all() :: [%Playlist{}]
end

defmodule Streamy.Playlists.PlaylistRepo do
  alias Streamy.Playlists.Playlist

  @type id :: Ecto.UUID.t()

  @callback get_all() :: [%Playlist{}]
  @callback create_playlist_item(id, id) :: %Streamy.Playlists.PlaylistItem{}
  @callback insert(Ecto.Changeset.t()) :: %Playlist{} | {:error, Ecto.Changeset.t()}
  @callback insert!(Ecto.Changeset.t()) :: %Playlist{}
end

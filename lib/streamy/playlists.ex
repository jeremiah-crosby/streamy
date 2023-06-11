defmodule Streamy.Playlists do
  alias Streamy.Playlists

  @type id :: Ecto.UUID.t()
  @type playlist :: %Playlists.Playlist{}
  @type playlist_list :: [playlist]

  @spec get_all() :: playlist_list
  def get_all() do
    repo().get_all()
  end

  @spec create_playlist_item(id, id) :: %Streamy.Playlists.PlaylistItem{}
  def create_playlist_item(playlist_id, video_id) do
    repo().create_playlist_item(playlist_id, video_id)
  end

  defp repo do
    Application.get_env(:streamy, __MODULE__)[:repo_impl]
  end
end

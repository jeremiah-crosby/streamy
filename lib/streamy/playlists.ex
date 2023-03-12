defmodule Streamy.Playlists do
  alias Streamy.Playlists

  @type playlist :: %Playlists.Playlist{}
  @type playlist_list :: [playlist]

  @spec get_all() :: playlist_list
  def get_all() do
    repo().get_all()
  end

  defp repo do
    Application.get_env(:streamy, __MODULE__)[:repo_impl]
  end
end

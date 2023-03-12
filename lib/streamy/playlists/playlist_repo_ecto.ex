defmodule Streamy.Playlists.PlaylistRepoEcto do
  alias Streamy.Repo
  alias Streamy.Playlists.Playlist
  alias Streamy.Playlists.PlaylistRepo

  @behaviour PlaylistRepo

  @impl PlaylistRepo
  def get_all() do
    Playlist |> Repo.all()
  end
end

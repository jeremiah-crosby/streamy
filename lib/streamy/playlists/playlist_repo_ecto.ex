defmodule Streamy.Playlists.PlaylistRepoEcto do
  alias Streamy.Repo
  alias Streamy.Playlists.Playlist
  alias Streamy.Playlists.PlaylistRepo
  alias Streamy.Videos.Video

  @behaviour PlaylistRepo

  @impl PlaylistRepo
  def get_all() do
    Playlist |> Repo.all()
  end

  @impl PlaylistRepo
  def create_playlist_item(playlist_id, video_id) do
    playlist = Playlist |> Repo.get!(playlist_id)
    playlist = Repo.preload(playlist, [:videos])
    playlist_changeset = Ecto.Changeset.change(playlist)
    video = Video |> Repo.get!(video_id)
    playlist_video_changeset = playlist_changeset |> Ecto.Changeset.put_assoc(:videos, [video])
    Repo.update!(playlist_video_changeset, returning: false)
  end

  @impl PlaylistRepo
  def insert(playlist_changeset) do
    Repo.insert(playlist_changeset)
  end

  @impl PlaylistRepo
  def insert!(playlist_changeset) do
    Repo.insert!(playlist_changeset)
  end
end

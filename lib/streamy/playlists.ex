defmodule Streamy.Playlists do
  alias Streamy.Playlists
  require Logger

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

  @spec insert(Ecto.Changeset.t()) :: %Playlists.Playlist{} | {:error, Ecto.Changeset.t()}
  def insert(playlist_attrs) do
    %Playlists.Playlist{}
    |> Playlists.Playlist.changeset(playlist_attrs)
    |> repo().insert()
  end

  @spec insert!(Ecto.Changeset.t()) :: %Playlists.Playlist{}
  def insert!(playlist) do
    repo().insert!(playlist)
  end

  defp repo do
    Application.get_env(:streamy, __MODULE__)[:repo_impl]
  end
end

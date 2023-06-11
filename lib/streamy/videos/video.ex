defmodule Streamy.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "videos" do
    field :location, :string
    field :title, :string
    field :folder_id, Ecto.UUID
    many_to_many :playlists, Streamy.Playlists.Playlist,
      join_through: Streamy.Playlists.PlaylistItem,
      join_keys: [video_id: :id, playlist_id: :id]

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title, :location])
    |> validate_required([:title, :location])
  end
end

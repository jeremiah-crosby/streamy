defmodule Streamy.Repo.Migrations.AddPlaylistItemsTable do
  use Ecto.Migration

  def change do
    create table(:playlist_items, primary_key: false) do
      add(:video_id, references(:videos, on_delete: :delete_all), primary_key: true)
      add(:playlist_id, references(:playlists, on_delete: :delete_all), primary_key: true)
      timestamps()
    end

    create(index(:playlist_items, [:playlist_id]))
    create(index(:playlist_items, [:video_id]))
  end
end

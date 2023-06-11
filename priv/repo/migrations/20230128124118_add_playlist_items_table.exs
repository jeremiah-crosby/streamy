defmodule Streamy.Repo.Migrations.AddPlaylistItemsTable do
  use Ecto.Migration

  def change do
    create table(:playlist_items, primary_key: false) do
      add :id, :uuid, primary_key: true
      add(:video_id, references(:videos, on_delete: :delete_all), primary_key: true)
      add(:playlist_id, references(:playlists, on_delete: :delete_all), primary_key: true)
      timestamps()
    end

    create unique_index(:playlist_items, [:playlist_id, :video_id])
  end
end

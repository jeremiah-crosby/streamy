defmodule Streamy.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :location, :string

      add :folder_id, references(:folders, type: :uuid)

      timestamps()
    end
  end
end

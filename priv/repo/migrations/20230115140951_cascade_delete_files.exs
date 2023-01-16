defmodule Streamy.Repo.Migrations.CascadeDeleteFiles do
  use Ecto.Migration

  def change do
    execute """
    ALTER TABLE videos RENAME TO _videos_old;
    """

    create table(:videos, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :location, :string

      add :folder_id, references(:folders, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    execute """
    INSERT INTO videos SELECT * FROM _videos_old;
    """

    execute """
    DROP table _videos_old;
    """
  end
end

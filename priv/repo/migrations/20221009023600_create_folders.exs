defmodule Streamy.Repo.Migrations.CreateFolders do
  use Ecto.Migration

  def change do
    create table(:folders, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :physical_path, :string

      timestamps()
    end
  end
end

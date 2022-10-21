defmodule Streamy.Videos.VideoRepo do
  import Ecto.Query
  alias Streamy.Videos.Video
  alias Streamy.Repo

  def get_all() do
    Video |> Repo.all()
  end

  def get_for_folder(folder_id) do
    Video
    |> where([video], video.folder_id == ^Ecto.UUID.dump!(folder_id))
    |> Repo.all()
  end

  def insert(video_changeset) do
    Repo.insert(video_changeset)
  end
end

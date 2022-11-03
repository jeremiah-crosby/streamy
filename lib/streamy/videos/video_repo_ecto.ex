defmodule Streamy.Videos.VideoRepoEcto do
  import Ecto.Query
  alias Streamy.Videos.Video
  alias Streamy.Repo
  alias Streamy.Videos.VideoRepo

  @behaviour VideoRepo

  @impl VideoRepo
  def get_all() do
    Video |> Repo.all()
  end

  @impl VideoRepo
  def get_for_folder(folder_id) do
    Video
    |> where([video], video.folder_id == ^Ecto.UUID.dump!(folder_id))
    |> order_by([video], video.title)
    |> Repo.all()
  end

  @impl VideoRepo
  def get_by_id(video_id) do
    Video |> Repo.get!(video_id)
  end

  @impl VideoRepo
  def insert(video_changeset) do
    Repo.insert(video_changeset)
  end
end

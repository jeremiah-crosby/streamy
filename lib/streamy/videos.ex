defmodule Streamy.Videos do
  alias Streamy.Videos

  @repo Application.get_env(:streamy, __MODULE__)[:repo_impl]

  @type id :: Ecto.UUID.t()
  @type video :: %Videos.Video{}
  @type video_list :: [video]

  @spec get_for_folder(id) :: video_list
  def get_for_folder(folder_id) do
    @repo.get_for_folder(folder_id)
  end

  @spec get_by_id(id) :: video | nil
  def get_by_id(video_id) do
    @repo.get_by_id(video_id)
  end
end

defmodule Streamy.Videos do
  alias Streamy.Videos
  alias Streamy.Videos.VideoRepo

  @type id :: Ecto.UUID.t()
  @type video :: %Videos.Video{}
  @type video_list :: [video]

  @spec get_for_folder(id) :: video_list
  def get_for_folder(folder_id) do
    VideoRepo.get_for_folder(folder_id)
  end

  @spec get_by_id(id) :: video | nil
  def get_by_id(video_id) do
    VideoRepo.get_by_id(video_id)
  end
end

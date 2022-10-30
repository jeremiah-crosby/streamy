defmodule Streamy.Videos do
  alias Streamy.Videos.VideoRepo

  def get_for_folder(folder_id) do
    VideoRepo.get_for_folder(folder_id)
  end

  def get_by_id(video_id) do
    VideoRepo.get_by_id(video_id)
  end
end

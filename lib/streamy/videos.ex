defmodule Streamy.Videos do
  alias Streamy.Videos.VideoRepo

  def get_for_folder(folder_id) do
    VideoRepo.get_for_folder(folder_id)
  end
end

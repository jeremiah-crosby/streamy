defmodule Streamy.Videos.Thumbnails.ThumbnailerFilesystem do
  alias Streamy.Videos.Thumbnails

  @behaviour Thumbnails.Thumbnailer
  @moduledoc """
  Retrieves and save thumbnails for videos.
  """

  @doc """
  Saves the thumbnail for the video located at `video_location` to path given by `output_path`.
  """
  @impl Thumbnails.Thumbnailer
  def save_thumbnail(video_location, output_path) do
    Thumbnex.create_thumbnail(video_location, output_path, max_width: 250, max_height: 250)
  end
end

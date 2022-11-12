defmodule Streamy.Videos.Thumbnails.Thumbnailer do
  @moduledoc """
  Retrieves and save thumbnails for videos.
  """

  @doc """
  Saves the thumbnail for the video.

  The first argument is the location of the video.

  The second argument is the location to save the thumbnail image.

  Return either `:ok` or an error-reason tuple.
  """
  @callback save_thumbnail(String.t(), String.t()) :: :ok | {:error, term()}
end

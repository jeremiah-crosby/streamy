defmodule Streamy.Folders.FolderSource do
  @moduledoc """
  Defines a source for folders.
  """

  @callback load_videos(String.t()) :: {:ok, list(%Streamy.Videos.Video{})} | {:error, String.t()}
end

defmodule Streamy.Folders.FolderSource do
  @moduledoc """
  Defines a source for folders.
  """

  @callback load_videos(String.t()) :: list(%Streamy.Videos.Video{})
end

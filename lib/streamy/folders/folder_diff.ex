defmodule Streamy.Folders.FolderDiff do
  @moduledoc """
  Calculates the diff of videos in the folder in the source vs the data store.
  """

  alias Streamy.Videos

  @doc """
  Takes as input the videos in the data store for a folder, and the videos in the folder source.
  Returns a 2-tuple with the first item the list of videos that should be deleted from the data repo,
  and the second item the list of videos that should be inserted.

  Comparison is made between videos in the repo and source only based on video location (path).
  """
  @spec calculate_diff([Videos.video()], [Videos.video()]) ::
          {[Videos.video()], [Videos.video()]}
  def calculate_diff(videos_in_data_store, videos_in_source) do
    data_store_locations = MapSet.new(videos_in_data_store, fn video -> video.location end)
    source_locations = MapSet.new(videos_in_source, fn video -> video.location end)

    delete_locations = MapSet.difference(data_store_locations, source_locations)
    insert_locations = MapSet.difference(source_locations, data_store_locations)

    {
      videos_in_data_store
      |> Enum.filter(&MapSet.member?(delete_locations, &1.location)),
      videos_in_source
      |> Enum.filter(&MapSet.member?(insert_locations, &1.location))
    }
  end
end

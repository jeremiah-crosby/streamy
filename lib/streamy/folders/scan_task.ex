defmodule Streamy.Folders.ScanTask do
  use Task

  require Logger

  alias Streamy.Folders
  alias Streamy.Videos
  alias Streamy.Videos

  def start_link(folder_id) do
    Task.start_link(__MODULE__, :run, [folder_id])
  end

  def run(folder_id, caller_pid) do
    Logger.debug("Scanning folder with ID [#{folder_id}]")

    folder = Folders.get_by_id(folder_id)
    Logger.debug("Loaded folder #{folder_id} from DB, location = #{folder.physical_path}")

    # TODO: Replace with injectable behavior
    with {:ok, videos} <-
           Streamy.Folders.Sources.FilesystemSource.load_videos(folder.physical_path),
         video_structs <- create_video_structs(videos, folder_id),
         :ok <- insert_videos(video_structs) do
      Logger.debug("Sending :folder_scanned message to #{inspect(caller_pid)}")
      send(caller_pid, {:folder_scanned, folder_id})
    end
  end

  defp create_video_structs(videos, folder_id) do
    Enum.map(
      videos,
      &(%{&1 | folder_id: folder_id} |> Videos.Video.changeset(%{}))
    )
  end

  defp insert_videos(videos) do
    for video <- videos do
      Videos.insert(video)
    end

    :ok
  end
end

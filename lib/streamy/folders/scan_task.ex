defmodule Streamy.Folders.ScanTask do
  use Task

  require Logger

  alias Streamy.Folders
  alias Streamy.Videos

  def start_link(folder_id) do
    Task.start_link(__MODULE__, :run, [folder_id])
  end

  def run(folder_id, caller_pid) do
    Logger.debug("Scanning folder with ID [#{folder_id}]")

    folder = Folders.get_by_id(folder_id)
    Logger.debug("Loaded folder #{folder_id} from DB, location = #{folder.physical_path}")

    # TODO: Replace with injectable behavior
    with {:ok, source_videos} <-
           Streamy.Folders.Sources.FilesystemSource.load_videos(folder.physical_path),
         repo_videos <- Streamy.Videos.get_for_folder(folder_id),
         {videos_to_delete, videos_to_insert} <-
           Streamy.Folders.FolderDiff.calculate_diff(repo_videos, source_videos),
         source_video_changesets <- create_video_changesets(videos_to_insert, folder_id),
         :ok <-
           insert_videos(source_video_changesets),
         :ok <- delete_videos(videos_to_delete) do
      Logger.debug("Sending :folder_scanned message to #{inspect(caller_pid)}")
      send(caller_pid, {:folder_scanned, folder_id})
    else
      {:error, message} -> send(caller_pid, {:folder_scan_error, folder_id, message})
    end
  end

  defp create_video_changesets(videos, folder_id) do
    Enum.map(
      videos,
      &(%{&1 | folder_id: folder_id} |> Videos.Video.changeset(%{}))
    )
  end

  defp insert_videos(videos) do
    try do
      for video <- videos do
        Videos.insert!(video)
      end

      :ok
    rescue
      e in RuntimeError -> {:error, e.message}
    end
  end

  defp delete_videos(videos) do
    try do
      for video <- videos do
        Videos.delete!(video)
      end

      :ok
    rescue
      e in RuntimeError -> {:error, e.message}
    end
  end
end

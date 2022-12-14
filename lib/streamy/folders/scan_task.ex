defmodule Streamy.Folders.ScanTask do
  use Task

  require Logger

  alias Streamy.Folders
  alias Streamy.Videos

  def start_link(folder_id, caller_pid) do
    Task.start_link(__MODULE__, :run, [folder_id, caller_pid])
  end

  def run(folder_id, caller_pid) do
    Logger.debug("Scanning folder with ID [#{folder_id}]")

    folder = Folders.get_by_id(folder_id)
    Logger.debug("Loaded folder #{folder_id} from DB, location = #{folder.physical_path}")

    config = Application.fetch_env!(:streamy, Streamy.Folders.Scanner)
    folder_source = config[:source]

    with {:ok, source_videos} <-
           folder_source.load_videos(folder.physical_path),
         repo_videos <- Streamy.Videos.get_for_folder(folder_id),
         {videos_to_delete, videos_to_insert} <-
           Streamy.Folders.FolderDiff.calculate_diff(repo_videos, source_videos),
         source_video_changesets <- create_video_changesets(videos_to_insert, folder_id),
         :ok <-
           insert_videos(source_video_changesets, config),
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

  defp insert_videos(videos, config) do
    try do
      for video <- videos do
        inserted = Videos.insert!(video)
        create_thumbnail(inserted, config)
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

  defp create_thumbnail(video, config) do
    base_path = config[:thumb_base_path]
    thumbnailer = config[:thumbnailer]
    output_path = Path.join(base_path, "#{video.id}.jpg")
    thumbnailer.save_thumbnail(video.location, output_path)
  end
end

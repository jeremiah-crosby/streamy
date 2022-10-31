defmodule Streamy.Folders.ScanTask do
  use Task

  require Logger

  alias Streamy.Folders
  alias Streamy.Videos
  alias Streamy.Videos.VideoRepo

  def start_link(folder_id) do
    Task.start_link(__MODULE__, :run, [folder_id])
  end

  def run(folder_id, caller_pid) do
    Logger.debug("Scanning folder with ID [#{folder_id}]")

    folder = Folders.get_by_id(folder_id)
    Logger.debug("Loaded folder #{folder_id} from DB, location = #{folder.physical_path}")

    # TODO: Replace with injectable behavior
    videos = Streamy.Folders.Sources.FilesystemSource.load_videos(folder.physical_path)

    videos =
      Enum.map(
        videos,
        &(%{&1 | folder_id: folder_id} |> Videos.Video.changeset(%{}))
      )

    for video <- videos do
      VideoRepo.insert(video)
    end

    Logger.debug("Sending :folder_scanned message to #{inspect(caller_pid)}")
    send(caller_pid, {:folder_scanned, folder_id})

    Process.sleep(3000)
  end
end

defmodule StreamyWeb.Library.LibraryLive do
  use StreamyWeb, :live_view

  alias StreamyWeb.Library.Components.Player
  alias StreamyWeb.Components.Modal
  alias StreamyWeb.Library.Components.FolderManager
  alias Streamy.PlayQueue

  require Logger

  def handle_info({:folder_selected, folder_id, folder_name}, socket) do
    show_folder_contents(folder_id, folder_name)
    {:noreply, socket}
  end

  @doc """
  A folder scan finished. Notifies the folder manager that it finished.
  """
  def handle_info({:folder_scanned, folder_id}, socket) do
    Logger.debug("Got :folder_scanned message for folder #{folder_id}")

    send_update(StreamyWeb.Library.Components.FolderManager,
      id: "folder_manager",
      scan_finished: folder_id
    )

    {:noreply, socket}
  end

  @doc """
  An error occurred scanning the folder.
  """
  def handle_info({:folder_scan_error, folder_id, error}, socket) do
    send_update(StreamyWeb.Library.Components.FolderManager,
      id: "folder_manager",
      scan_finished: folder_id
    )

    {:noreply, socket |> put_flash(:error, error)}
  end

  @doc """
  Play a single video.
  """
  def handle_info({:play_video, video_id}, socket) do
    Modal.open("player_modal")
    PlayQueue.clear()
    PlayQueue.add_video(video_id)
    Player.play_queue("player")
    {:noreply, socket}
  end

  @doc """
  Play an entire folder.
  """
  def handle_info({:play_folder, folder_id}, socket) do
    Modal.open("player_modal")
    PlayQueue.clear()
    PlayQueue.add_folder(folder_id)
    Player.play_queue("player")
    {:noreply, socket}
  end

  @doc """
  Play an entire folder in random order.
  """
  def handle_info({:shuffle_folder, folder_id}, socket) do
    Modal.open("player_modal")
    PlayQueue.clear()
    PlayQueue.add_folder(folder_id)
    PlayQueue.shuffle()
    Player.play_queue("player")
    {:noreply, socket}
  end

  @doc """
  A folder was selected for adding to library, so send to folder manager to add it.
  """
  def handle_info([select_folder_to_add: path], socket) do
    FolderManager.add_folder("folder_manager", path)
    {:noreply, socket}
  end

  defp show_folder_contents(folder_id, name) do
    send_update(StreamyWeb.Library.Components.VideoList,
      id: "video_list",
      folderid: folder_id,
      name: name
    )
  end
end

defmodule StreamyWeb.Library.LibraryLive do
  use StreamyWeb, :live_view

  alias StreamyWeb.Library.Components.Player
  alias StreamyWeb.Components.Modal
  alias StreamyWeb.Library.Components.FolderManager

  require Logger

  def handle_info({:folder_selected, folder_id, folder_name}, socket) do
    show_folder_contents(folder_id, folder_name)
    {:noreply, socket}
  end

  def handle_info({:folder_scanned, folder_id}, socket) do
    Logger.debug("Got :folder_scanned message for folder #{folder_id}")

    send_update(StreamyWeb.Library.Components.FolderManager,
      id: "folder_manager",
      scan_finished: folder_id
    )

    {:noreply, socket}
  end

  def handle_info({:play_video, video_url}, socket) do
    Modal.open("player_modal")
    Player.play_video("player", video_url)
    {:noreply, socket}
  end

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

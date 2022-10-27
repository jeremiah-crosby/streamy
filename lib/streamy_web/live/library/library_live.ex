defmodule StreamyWeb.Library.LibraryLive do
  use StreamyWeb, :live_view

  alias StreamyWeb.Library.Components.Player

  require Logger

  def handle_info({:folder_selected, folder_id}, socket) do
    show_folder_contents(folder_id)
    {:noreply, socket}
  end

  def handle_info({:folder_scanned, folder_id}, socket) do
    Logger.debug("Got :folder_scanned message for folder #{folder_id}")
    send_update StreamyWeb.Library.Components.FolderManager, id: "folder_manager", scan_finished: folder_id
    {:noreply, socket}
  end

  def handle_info({:play_video, video_url}, socket) do
    Player.play_video("player", video_url)
    {:noreply, socket}
  end

  defp show_folder_contents(folder_id) do
    send_update StreamyWeb.Library.Components.VideoList, id: "video_list", folderid: folder_id
  end

end

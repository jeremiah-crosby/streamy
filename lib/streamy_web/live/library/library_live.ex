defmodule StreamyWeb.Library.LibraryLive do
  use StreamyWeb, :live_view

  def handle_info({:folder_selected, folder_id}, socket) do
    send_update StreamyWeb.Library.Components.VideoList, id: "video_list", folderid: folder_id
    {:noreply, socket}
  end

end

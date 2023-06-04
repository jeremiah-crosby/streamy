defmodule StreamyWeb.Library.Components.VideoList do
  use StreamyWeb, :live_component

  require Logger

  alias Streamy.Videos
  alias StreamyWeb.Components.Modal

  @impl true
  def mount(socket) do
    {:ok, assign(socket, videos: [], folder_id: nil, folder_name: nil)}
  end

  # Play the selected video.
  @impl true
  def handle_event("play_video", %{"videoid" => video_id}, socket) do
    send(self(), {:play_video, video_id})
    {:noreply, socket}
  end

  # Show playlist browser to add video to
  def handle_event("add_to_playlist", %{"videoid" => video_id}, socket) do
    Modal.open("add_to_playlist_modal")
    {:noreply, assign(socket, add_to_playlist_video: video_id)}
  end

  # Play the entire folder.
  @impl true
  def handle_event("play_folder", %{}, socket) do
    send(self(), {:play_folder, socket.assigns.folder_id})
    {:noreply, socket}
  end

  # Play the entire folder in random order.
  @impl true
  def handle_event("shuffle_folder", %{}, socket) do
    send(self(), {:shuffle_folder, socket.assigns.folder_id})
    {:noreply, socket}
  end

  @impl true
  def update(%{id: _id, folderid: folderid, name: name}, socket) do
    videos = if folderid != nil do
      Videos.get_for_folder(folderid)
    else
      []
    end
    {:ok, assign(socket, videos: videos, folder_id: folderid, folder_name: name)}
  end

  @impl true
  def update(%{id: _id}, socket) do
    {:ok, assign(socket, :videos, [])}
  end
end

defmodule StreamyWeb.Library.Components.VideoList do
  use StreamyWeb, :live_component

  require Logger

  alias Streamy.Videos

  @impl true
  def mount(socket) do
    {:ok, assign(socket, videos: [], folder_id: nil, folder_name: nil)}
  end

  @doc """
  Play the selected video.
  """
  @impl true
  def handle_event("play_video", %{"videoid" => video_id}, socket) do
    send(self(), {:play_video, video_id})
    {:noreply, socket}
  end

  @doc """
  Play the entire folder.
  """
  @impl true
  def handle_event("play_folder", %{}, socket) do
    send(self(), {:play_folder, socket.assigns.folder_id})
    {:noreply, socket}
  end

  @doc """
  Play the entire folder in random order.
  """
  @impl true
  def handle_event("shuffle_folder", %{}, socket) do
    send(self(), {:shuffle_folder, socket.assigns.folder_id})
    {:noreply, socket}
  end

  @impl true
  def update(%{id: _id, folderid: folderid, name: name}, socket) do
    videos = Videos.get_for_folder(folderid)
    {:ok, assign(socket, videos: videos, folder_id: folderid, folder_name: name)}
  end

  @impl true
  def update(%{id: _id}, socket) do
    {:ok, assign(socket, :videos, [])}
  end
end

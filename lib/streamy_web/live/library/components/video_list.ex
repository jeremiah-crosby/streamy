defmodule StreamyWeb.Library.Components.VideoList do
  use StreamyWeb, :live_component

  require Logger

  alias Streamy.Videos

  @impl true
  def mount(socket) do
    {:ok, assign(socket, videos: [])}
  end

  @impl true
  def handle_event("play_video", %{"location" => video_id}, socket) do
    send(self(), {:play_video, video_id})
    {:noreply, socket}
  end

  @impl true
  def update(%{id: _id, folderid: folderid}, socket) do
    Logger.debug("Folder list update: #{folderid}")
    videos = Videos.get_for_folder(folderid)
    {:ok, assign(socket, :videos, videos)}
  end

  @impl true
  def update(%{id: _id}, socket) do
    Logger.debug("Folder list update: no folder")
    {:ok, assign(socket, :videos, [])}
  end
end

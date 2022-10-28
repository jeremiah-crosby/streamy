defmodule StreamyWeb.Library.Components.Player do
  use StreamyWeb, :live_component

  require Logger

  @impl true
  def mount(socket) do
    {:ok,
     assign(socket,
       source: "",
       open: false
     )}
  end

  @impl true
  def update(%{id: _id, play_video: source}, socket) do
    Logger.debug("Player: got :play_video message for source #{source}")
    {:ok, assign(socket, open: true, source: source)}
  end

  @impl true
  def update(%{id: _id}, socket) do
    {:ok, socket}
  end

  def play_video(component_id, source) do
    send_update(__MODULE__, id: component_id, play_video: source)
  end
end

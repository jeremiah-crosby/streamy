defmodule StreamyWeb.Library.Components.Player do
  use StreamyWeb, :live_component

  require Logger

  alias Streamy.PlayQueue

  @impl true
  def mount(socket) do
    {:ok,
     assign(socket,
       source: nil
     )}
  end

  @impl true
  def handle_event("next_video", %{}, socket) do
    do_move_next(socket)
  end

  def handle_event("previous_video", %{}, socket) do
    do_move_previous(socket)
  end

  def handle_event("keyboard_shortcut", %{"key" => "x"}, socket) do
    do_move_previous(socket)
  end

  def handle_event("keyboard_shortcut", %{"key" => "c"}, socket) do
    do_move_next(socket)
  end

  def handle_event("keyboard_shortcut", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def update(%{id: _id, play_queue: _}, socket) do
    case PlayQueue.move_next() do
      :empty -> {:ok, assign(socket, source: nil)}
      {:ok, video} -> {:ok, assign(socket, source: video.location, filename: video.title)}
    end
  end

  @impl true
  def update(%{id: _id}, socket) do
    {:ok, socket}
  end

  def play_queue(component_id) do
    send_update(__MODULE__, id: component_id, play_queue: true)
  end

  defp do_move_previous(socket) do
    ret =
      case PlayQueue.move_previous() do
        :empty -> {:noreply, assign(socket, source: nil)}
        {:ok, video} -> {:noreply, assign(socket, source: video.location)}
      end

    ret
  end

  defp do_move_next(socket) do
    ret =
      case PlayQueue.move_next() do
        :empty -> {:noreply, assign(socket, source: nil)}
        {:ok, video} -> {:noreply, assign(socket, source: video.location)}
      end

    ret
  end
end

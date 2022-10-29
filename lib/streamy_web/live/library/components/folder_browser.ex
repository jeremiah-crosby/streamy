defmodule StreamyWeb.Library.Components.FolderBrowser do
  @moduledoc "A component to navigate the filesystem and select a folder."

  use StreamyWeb, :live_component

  require Logger

  @impl true
  def mount(socket) do
    cwd = File.cwd!()
    {:ok, assign(socket, curr_folder: cwd, child_folders: get_child_folders(cwd))}
  end

  @impl true
  def handle_event("select_folder", _, socket) do
    send(self(), select_folder_to_add: socket.assigns.curr_folder)
    {:noreply, socket}
  end

  @impl true
  def handle_event("navigate_back", _, socket) do
    new_root = socket.assigns.curr_folder |> Path.join("..") |> Path.expand()
    Logger.debug("new_root = #{new_root}")
    socket = assign(socket, curr_folder: new_root, child_folders: get_child_folders(new_root))
    {:noreply, socket}
  end

  @impl true
  def handle_event("navigate_folder", %{"folder" => folder}, socket) do
    new_root = Path.join(socket.assigns.curr_folder, folder)
    socket = assign(socket, curr_folder: new_root, child_folders: get_child_folders(new_root))
    {:noreply, socket}
  end

  defp get_child_folders(root) do
    files = File.ls!(root)
    files |> Enum.filter(&(Path.join(root, &1) |> File.dir?())) |> Enum.sort()
  end
end

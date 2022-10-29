defmodule StreamyWeb.Library.Components.FolderManager do
  use StreamyWeb, :live_component

  require Logger
  alias Streamy.Folders
  alias StreamyWeb.Components.Modal

  @impl true
  def mount(socket) do
    {:ok,
     assign(socket,
       folders: Folders.get_all(),
       scanning_folders: []
     )}
  end

  @impl true
  def handle_event("select_folder", %{"folderid" => folder_id}, socket) do
    send_folder_selected(folder_id)
    {:noreply, socket}
  end

  def handle_event("scan_folder", %{"folderid" => folder_id}, socket) do
    Streamy.Folders.Scanner.scan_folder(folder_id, self())
    {:noreply, assign(socket, scanning_folders: [folder_id | socket.assigns.scanning_folders])}
  end

  def handle_event("browse_folder", _, socket) do
    Modal.open("folder_browser_modal")
    {:noreply, socket}
  end

  def handle_event(:update_folder_list, %{}, socket) do
    {:noreply, assign(socket, folders: Folders.get_all())}
  end

  @impl true
  def update(%{id: _id, scan_finished: folder_id}, socket) do
    Logger.debug("Folder Manager: got :scan_finished message for folder #{folder_id}")
    send_folder_selected(folder_id)

    {:ok,
     assign(socket, scanning_folders: List.delete(socket.assigns.scanning_folders, folder_id))}
  end

  @impl true
  def update(%{id: _id, add_folder: path}, socket) do
    Folders.create_folder_from_path(path)
    Modal.close("folder_browser_modal")
    update_folders()

    {:ok, socket}
  end

  @impl true
  def update(%{id: _id}, socket) do
    {:ok, socket}
  end

  def add_folder(component_id, path) do
    send_update(__MODULE__, id: component_id, add_folder: path)
  end

  defp send_folder_selected(folder_id) do
    folder = Folders.get_by_id(folder_id)
    send(self(), {:folder_selected, folder_id, folder.name})
  end

  defp update_folders do
    send(self(), {:update_folder_list})
  end
end

defmodule StreamyWeb.Library.Components.FolderManager do
  use StreamyWeb, :live_component

  require Logger
  alias Streamy.Folders

  @impl true
  def mount(socket) do
    {:ok,
     assign(socket,
       folders: Folders.get_all(),
       changeset: Folders.Folder.changeset(%Folders.Folder{}, %{}),
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

  def handle_event("add_folder", %{"folder" => folder_params}, socket) do
    Folders.create_folder(folder_params)
    update_folders()
    {:noreply, socket}
  end

  def handle_event(:update_folder_list, %{}, socket) do
    {:noreply, assign(socket, folders: Folders.get_all())}
  end

  @impl true
  def update(%{id: _id, scan_finished: folder_id}, socket) do
    Logger.debug("Folder Manager: got :scan_finished message for folder #{folder_id}")
    send_folder_selected(folder_id)
    {:ok, assign(socket, scanning_folders: List.delete(socket.assigns.scanning_folders, folder_id))}
  end

  @impl true
  def update(%{id: _id}, socket) do
    {:ok, socket}
  end

  defp send_folder_selected(folder_id) do
    send(self(), {:folder_selected, folder_id})
  end

  defp update_folders do
    send(self(), {:update_folder_list})
  end
end

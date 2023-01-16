defmodule FolderListItem do
  defstruct [:id, :name, :scanning?]

  def from_folder(folder) do
    %FolderListItem{id: folder.id, name: folder.name, scanning?: false}
  end
end

defmodule StreamyWeb.Library.Components.FolderManager do
  @moduledoc """
  Module to manage folders.

  When a folder is scanned, the scanning task will send a message to self() when done, so
  the parent LiveView must handle the message and call the :scan_finished update to notify
  this component.
  """
  use StreamyWeb, :live_component

  require Logger
  alias Streamy.Folders
  alias StreamyWeb.Components.Modal

  @impl true
  def mount(socket) do
    {:ok,
     assign(socket,
       folders: get_folder_list_items(),
       delete_folder_id: nil,
       delete_folder_name: nil
     )}
  end

  @impl true
  def handle_event("select_folder", %{"folderid" => folder_id}, socket) do
    send_folder_selected(folder_id)
    {:noreply, socket}
  end

  def handle_event("start_delete_folder", %{"folderid" => folder_id, "folder-name" => folder_name}, socket) do
    Modal.open("delete_folder_modal")
    {:noreply, assign(socket, delete_folder_id: folder_id, delete_folder_name: folder_name)}
  end

  def handle_event("cancel_delete_folder", _, socket) do
    Modal.close("delete_folder_modal")
    {:noreply, assign(socket, delete_folder_id: nil, delete_folder_name: nil)}
  end

  def handle_event("confirm_delete_folder", _, socket) do
    Modal.close("delete_folder_modal")
    Streamy.Folders.delete(socket.assigns.delete_folder_id)
    send_folder_deleted(socket.assigns.delete_folder_id)
    {:noreply, assign(socket, delete_folder_id: nil, delete_folder_name: nil, folders: get_folder_list_items())}
  end

  def handle_event("scan_folder", %{"folderid" => folder_id}, socket) do
    Streamy.Folders.Scanner.scan_folder(folder_id, self())
    updated_folders = set_folder_scanning(socket.assigns.folders, folder_id, true)
    {:noreply, assign(socket, folders: updated_folders)}
  end

  def handle_event("browse_folder", _, socket) do
    Modal.open("folder_browser_modal")
    {:noreply, socket}
  end

  def handle_event(:update_folder_list, %{}, socket) do
    {:noreply, assign(socket, folders: get_folder_list_items())}
  end

  @impl true
  def update(%{id: _id, scan_finished: folder_id}, socket) do
    Logger.debug("Folder Manager: got :scan_finished message for folder #{folder_id}")
    send_folder_selected(folder_id)
    updated_folders = set_folder_scanning(socket.assigns.folders, folder_id, false)

    {:ok, assign(socket, folders: updated_folders)}
  end

  @impl true
  def update(%{id: _id, add_folder: path}, socket) do
    case Folders.create_folder_from_path(path) do
      {:ok, folder} ->
        Modal.close("folder_browser_modal")
        Streamy.Folders.Scanner.scan_folder(folder.id, self())

        {:ok,
         assign(socket,
           folders: get_folder_list_items()
         )}

      {:error, error} ->
        Modal.close("folder_browser_modal")
        {:ok, put_flash(socket, :error, error)}
    end
  end

  @impl true
  def update(%{id: _id}, socket) do
    {:ok, socket}
  end

  def add_folder(component_id, path) do
    send_update(__MODULE__, id: component_id, add_folder: path)
  end

  defp get_folder_list_items() do
    Enum.map(Folders.get_all(), fn folder -> FolderListItem.from_folder(folder) end)
  end

  defp send_folder_selected(folder_id) do
    folder = Folders.get_by_id(folder_id)
    send(self(), {:folder_selected, folder_id, folder.name})
  end

  defp send_folder_deleted(folder_id) do
    send(self(), {:folder_deleted, folder_id})
  end

  defp set_folder_scanning(folders, folder_id, scanning?) do
    Enum.map(folders, fn folder ->
      if folder.id == folder_id do
        %FolderListItem{folder | scanning?: scanning?}
      else
        folder
      end
    end)
  end
end

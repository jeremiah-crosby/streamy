defmodule StreamyWeb.Library.Components.FolderManager do
  use StreamyWeb, :live_component

  alias Streamy.Folders

  @impl true
  def mount(socket) do
    {:ok, assign(socket, folders: Folders.FolderRepo.get_all())}
  end

  @impl true
  def handle_event("select_folder", %{"folderid" => folder_id}, socket) do
    send self(), {:folder_selected, folder_id}
    {:noreply, socket}
  end
end

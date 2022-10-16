defmodule StreamyWeb.Library.Components.FolderManager do
  use StreamyWeb, :live_component

  alias Streamy.Folders

  @impl true
  def mount(socket) do
    {:ok,
     assign(socket,
       folders: Folders.get_all(),
       changeset: Folders.Folder.changeset(%Folders.Folder{}, %{})
     )}
  end

  @impl true
  def handle_event("select_folder", %{"folderid" => folder_id}, socket) do
    send(self(), {:folder_selected, folder_id})
    {:noreply, socket}
  end

  def handle_event("add_folder", %{"folder" => folder_params}, socket) do
    Folders.create_folder(folder_params)
    update_folders()
    {:noreply, socket}
  end

  def handle_event(:update_folder_list, %{}, socket) do
    {:noreply, assign(socket, folders: Folders.get_all())}
  end

  defp update_folders do
    send(self(), {:update_folder_list})
  end
end

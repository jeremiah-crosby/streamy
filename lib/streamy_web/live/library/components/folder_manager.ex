defmodule StreamyWeb.Library.Components.FolderManager do
  use StreamyWeb, :live_component

  alias Streamy.Folders

  @impl true
  def mount(socket) do
    {:ok, assign(socket, folders: Folders.FolderRepo.get_all())}
  end
end

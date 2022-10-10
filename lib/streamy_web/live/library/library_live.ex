defmodule StreamyWeb.Library.LibraryLive do
  use StreamyWeb, :live_view

  alias Streamy.Folders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, folders: Folders.FolderRepo.get_all())}
  end

end

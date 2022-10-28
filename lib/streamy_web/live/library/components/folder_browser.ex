defmodule StreamyWeb.Library.Components.FolderBrowser do
  @moduledoc "A component to navigate the filesystem and select a folder."

  use StreamyWeb, :live_component

  @impl true
  def mount(socket) do
    cwd = File.cwd!()
    {:ok, assign(socket, curr_folder: cwd, child_folders: get_child_folders(cwd))}
  end

  defp get_child_folders(root) do
    File.ls!(root)
    |> Enum.filter(&File.dir?(&1))
  end
end

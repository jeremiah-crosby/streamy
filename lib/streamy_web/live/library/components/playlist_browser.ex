defmodule StreamyWeb.Library.Components.PlaylistBrowser do
  @moduledoc "A component to view all playlists."

  use StreamyWeb, :live_component

  require Logger

  @impl true
  def mount(socket) do
    playlists = Streamy.Playlists.get_all()
    {:ok, assign(socket, playlists: playlists)}
  end
end

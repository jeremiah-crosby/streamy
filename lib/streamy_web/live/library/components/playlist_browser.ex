defmodule StreamyWeb.Library.Components.PlaylistBrowser do
  @moduledoc "A component to view all playlists. Use target attribute to pass in ID of component to handle event when a playlist is selected.
  The event will get the playlist ID in the 'playlist' field.
  "

  use StreamyWeb, :live_component

  require Logger

  @impl true
  def mount(socket) do
    playlists = Streamy.Playlists.get_all()
    {:ok, assign(socket, playlists: playlists)}
  end
end

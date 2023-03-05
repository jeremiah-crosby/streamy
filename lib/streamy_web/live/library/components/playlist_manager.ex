defmodule StreamyWeb.Library.Components.PlaylistManager do
  @moduledoc """
  Component to manage playlists.
  """
  use StreamyWeb, :live_component

  require Logger

  @impl true
  def mount(socket) do
    {:ok, assign(socket, playlists: [])}
  end
end

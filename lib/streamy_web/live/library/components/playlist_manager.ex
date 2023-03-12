defmodule StreamyWeb.Library.Components.PlaylistManager do
  @moduledoc """
  Component to manage playlists.
  """
  use StreamyWeb, :live_component

  require Logger
  alias Streamy.Playlists

  @impl true
  def mount(socket) do
    {:ok, assign(socket, playlists: get_playlist_items())}
  end

  defp get_playlist_items() do
    Playlists.get_all()
  end
end

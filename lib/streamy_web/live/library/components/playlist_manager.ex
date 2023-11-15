defmodule StreamyWeb.Library.Components.PlaylistManager do
  @moduledoc """
  Component to manage playlists.
  """
  use StreamyWeb, :live_component

  require Logger
  alias Streamy.Playlists
  alias Streamy.Playlists.Playlist

  @impl true
  def mount(socket) do
    {:ok, assign(socket, playlists: get_playlist_items(), form: to_form(Playlist.changeset(%Playlists.Playlist{}, %{})))}
  end

  @impl true
  def handle_event("validate", %{"playlist" => params}, socket) do
    form =
      %Playlists.Playlist{}
      |> Playlist.changeset(params)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"playlist" => playlist_params}, socket) do
    Logger.debug("Playlist_params = #{inspect playlist_params}")
    case Playlists.insert(playlist_params) do
      {:ok, playlist} ->
        {:noreply,
         assign(socket, playlists: get_playlist_items())
         |> put_flash(:info, "Playlist created")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp get_playlist_items() do
    Playlists.get_all()
  end
end

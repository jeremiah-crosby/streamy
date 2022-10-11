defmodule StreamyWeb.Library.Components.VideoList do
  use StreamyWeb, :live_component

  alias Streamy.Videos

  @impl true
  def mount(socket) do
    {:ok, assign(socket, videos: [])}
  end
end

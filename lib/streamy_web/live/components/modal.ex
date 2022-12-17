defmodule StreamyWeb.Components.Modal do
  @moduledoc "Live component for showing a modal dialog"
  use StreamyWeb, :live_component

  require Logger

  alias Phoenix.LiveView.JS

  def hide_modal(component_id, js \\ %JS{}) do
    js
    |> JS.push("closed", target: component_id)
  end

  @impl true
  def mount(socket) do
    {:ok,
     assign(socket,
       open: false
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @open do %>
        <input type="checkbox" id={"modal-#{@id}"} class="modal-toggle" checked/>
      <% else %>
        <input type="checkbox" id={"modal-#{@id}"} class="modal-toggle" />
      <% end %>
      <%= if @open do %>
      <div class="modal">
        <div class="modal-box w-11/12 max-w-5xl"
          phx-click-away={hide_modal(@myself)}
          phx-window-keydown={hide_modal(@myself)}
          phx-key="escape">
          <div>
            <button class="btn btn-sm btn-circle absolute right-2 top-2" phx-click={hide_modal(@myself)}>✕</button>
          </div>
          <div class="pt-6">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("closed", _, socket) do
    socket =
      socket
      |> assign(open: false)

    {:noreply, socket}
  end

  @impl true
  def update(%{id: id, open: open}, socket) do
    {:ok, assign(socket, id: id, open: open)}
  end

  @impl true
  def update(%{id: id, open: true, inner_block: inner_block}, socket) do
    {:ok, assign(socket, id: id, open: true, inner_block: inner_block)}
  end

  @impl true
  def update(%{id: id, inner_block: inner_block}, socket) do
    {:ok, assign(socket, id: id, inner_block: inner_block)}
  end

  def open(component_id) do
    send_update(__MODULE__, id: component_id, open: true)
  end

  def close(component_id) do
    send_update(__MODULE__, id: component_id, open: false)
  end
end

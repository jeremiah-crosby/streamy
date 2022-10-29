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
          <div class="phx-modal" phx-remove={hide_modal(@myself)}>
              <div
                  class="phx-modal-content"
                  phx-click-away={hide_modal(@myself)}
                  phx-window-keydown={hide_modal(@myself)}
                  phx-key="escape">
                  <button class="phx-modal-close" phx-click={hide_modal(@myself)}>✖</button>
                  <%= render_slot(@inner_block) %>
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
  def update(%{id: _id, open: open}, socket) do
    {:ok, assign(socket, open: open)}
  end

  @impl true
  def update(%{id: _id, open: true, inner_block: inner_block}, socket) do
    {:ok, assign(socket, open: true, inner_block: inner_block)}
  end

  @impl true
  def update(%{id: _id, inner_block: inner_block}, socket) do
    {:ok, assign(socket, inner_block: inner_block)}
  end

  def open(component_id) do
    send_update(__MODULE__, id: component_id, open: true)
  end

  def close(component_id) do
    send_update(__MODULE__, id: component_id, open: false)
  end
end

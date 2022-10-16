defmodule Streamy.Folders.Scanner do
  use GenServer

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @doc """
  Starts the scanner.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end
end

defmodule Streamy.Folders.Scanner do
  use Supervisor

  @impl true
  def init(_init_arg) do
    children = [
      {Task.Supervisor, name: Streamy.Folders.Scanner.TaskSupervisor}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Starts the scanner.
  """
  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def scan_folder(folder_id) do
    Task.Supervisor.async_nolink(
      Streamy.Folders.Scanner.TaskSupervisor,
      Streamy.Folders.ScanTask,
      :run,
      [folder_id],
      []
    )
  end
end

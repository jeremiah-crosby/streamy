defmodule Streamy.PlayQueue do
  @moduledoc """
  The queue of videos to be played.
  """
  use GenServer

  alias Streamy.Videos

  require Logger

  # API

  @type id :: Ecto.UUID.t()

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Clear the queue.
  """
  @spec clear() :: :ok
  def clear() do
    GenServer.call(__MODULE__, :clear)
  end

  @doc """
  Move to the next video in the queue and return it, or :empty if empty.
  """
  @spec move_next() :: :empty | {:ok, %Videos.Video{}}
  def move_next() do
    case GenServer.call(__MODULE__, :move_next) do
      :empty -> :empty
      {:ok, id} -> {:ok, Videos.get_by_id(id)}
    end
  end

  @doc """
  Add a single video to the queue
  """
  @spec add_video(id) :: :ok
  def add_video(video) do
    GenServer.call(__MODULE__, {:add_video, video})
  end

  @doc """
  Add all the videos from a folder to the queue
  """
  @spec add_folder(id) :: :ok
  def add_folder(folder) do
    GenServer.call(__MODULE__, {:add_folder, folder})
  end

  # Callbacks

  @impl true
  def init(:ok) do
    {:ok, %{videos_left: :queue.new(), already_played: :queue.new()}}
  end

  @impl true
  def handle_call(:clear, _from, state) do
    {:reply, :ok, %{state | :videos_left => :queue.new(), :already_played => :queue.new()}}
  end

  @impl true
  def handle_call(:move_next, _from, state) do
    videos_left = Map.get(state, :videos_left)
    already_played = Map.get(state, :already_played)

    {new_videos_left, new_already_played, reply} =
      case :queue.out(videos_left) do
        {{:value, head}, new_queue} ->
          {new_queue, :queue.in_r(head, already_played), {:ok, head}}

        {:empty, new_queue} ->
          {new_queue, already_played, :empty}
      end

    new_state = %{state | :videos_left => new_videos_left, :already_played => new_already_played}

    {:reply, reply, new_state}
  end

  @impl true
  def handle_call({:add_video, video}, _from, state) do
    videos_left = Map.get(state, :videos_left)
    videos_left = :queue.in(video, videos_left)
    {:reply, :ok, %{state | :videos_left => videos_left}}
  end

  @impl true
  def handle_call({:add_folder, folder}, _from, state) do
    videos_in_folder = Videos.get_for_folder(folder) |> Enum.map(& &1.id)
    videos_left = Map.get(state, :videos_left)

    videos_left =
      Enum.reduce(
        videos_in_folder,
        videos_left,
        fn v, q -> :queue.in(v, q) end
      )

    {:reply, :ok, %{state | :videos_left => videos_left}}
  end
end

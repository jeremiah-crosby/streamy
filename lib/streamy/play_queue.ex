defmodule Streamy.PlayQueue do
  @moduledoc """
  The queue of videos to be played.
  """
  use GenServer

  alias Streamy.Videos

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
  Get the next item in the queue, or :empty if empty.
  """
  @spec get_next() :: :empty | {:ok, %Videos.Video{}}
  def get_next() do
    case GenServer.call(__MODULE__, :get_next) do
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
    {:ok, %{video_queue: :queue.new()}}
  end

  @impl true
  def handle_call(:clear, _from, state) do
    {:reply, :ok, %{state | :video_queue => :queue.new()}}
  end

  @impl true
  def handle_call(:get_next, _from, state) do
    video_queue = Map.get(state, :video_queue)

    {new_queue, reply} =
      case :queue.out(video_queue) do
        {{:value, head}, new_queue} -> {new_queue, {:ok, head}}
        {:empty, new_queue} -> {new_queue, :empty}
      end

    new_state = %{state | :video_queue => new_queue}

    {:reply, reply, new_state}
  end

  @impl true
  def handle_call({:add_video, video}, _from, state) do
    video_queue = Map.get(state, :video_queue)
    new_queue = :queue.in(video, video_queue)
    {:reply, :ok, %{state | :video_queue => new_queue}}
  end

  @impl true
  def handle_call({:add_folder, folder}, _from, state) do
    videos_in_folder = Videos.get_for_folder(folder) |> Enum.map(& &1.id)
    video_queue = Map.get(state, :video_queue)

    new_queue =
      Enum.reduce(
        videos_in_folder,
        video_queue,
        fn v, q -> :queue.in(v, q) end
      )

    {:reply, :ok, %{state | :video_queue => new_queue}}
  end
end

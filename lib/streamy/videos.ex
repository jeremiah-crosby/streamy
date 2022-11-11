defmodule Streamy.Videos do
  alias Streamy.Videos

  @type id :: Ecto.UUID.t()
  @type video :: %Videos.Video{}
  @type video_list :: [video]

  @spec get_for_folder(id) :: video_list
  def get_for_folder(folder_id) do
    repo().get_for_folder(folder_id)
  end

  @spec get_by_id(id) :: video | nil
  def get_by_id(video_id) do
    repo().get_by_id(video_id)
  end

  @spec insert(Ecto.Changeset.t()) :: %Videos.Video{} | {:error, Ecto.Changeset.t()}
  def insert(video) do
    repo().insert(video)
  end

  @spec insert!(Ecto.Changeset.t()) :: %Videos.Video{}
  def insert!(video) do
    repo().insert!(video)
  end

  @spec delete(video) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete(video) do
    repo().delete(video)
  end

  @spec delete!(video) :: :ok
  def delete!(video) do
    repo().delete!(video)
  end

  defp repo do
    Application.get_env(:streamy, __MODULE__)[:repo_impl]
  end
end

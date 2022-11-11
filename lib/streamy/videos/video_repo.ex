defmodule Streamy.Videos.VideoRepo do
  alias Streamy.Videos.Video

  @callback get_all() :: [%Video{}]

  @callback get_for_folder(Ecto.UUID.t()) :: [%Video{}]

  @callback get_by_id(Ecto.UUID.t()) :: %Video{}

  @callback insert(Ecto.Changeset.t()) :: %Video{} | {:error, Ecto.Changeset.t()}

  @callback insert!(Ecto.Changeset.t()) :: %Video{}

  @callback delete(Streamy.Videos.video()) ::
              {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @callback delete!(Streamy.Videos.video()) :: :ok
end

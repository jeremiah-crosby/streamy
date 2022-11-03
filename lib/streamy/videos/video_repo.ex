defmodule Streamy.Videos.VideoRepo do
  alias Streamy.Videos.Video

  @callback get_all() :: [%Video{}]

  @callback get_for_folder(Ecto.UUID.t()) :: [%Video{}]

  @callback get_by_id(Ecto.UUID.t()) :: %Video{}

  @callback insert(Ecto.Changeset.t()) :: %Video{}
end

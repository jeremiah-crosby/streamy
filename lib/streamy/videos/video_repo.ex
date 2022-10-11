defmodule Streamy.Videos.VideoRepo do
  alias Streamy.Videos.Video
  alias Streamy.Repo

  def get_all() do
    Video |> Repo.all()
  end

end

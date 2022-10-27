defmodule StreamyWeb.VideoStreamController do
  use StreamyWeb, :controller

  import Plug.Conn

  @doc """
  Proxies a local video file. Takes absolute local path as query string param.
  """
  def stream(conn, %{"path" => path}) do
    send_file(conn, 200, path)
  end
end

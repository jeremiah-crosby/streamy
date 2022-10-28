defmodule StreamyWeb.VideoStreamController do
  use StreamyWeb, :controller

  require Logger

  import Plug.Conn

  @doc """
  Proxies a local video file. Takes absolute local path as query string param.
  """
  def stream(conn, %{"path" => path}) do
    stats = File.stat!(path)
    filesize = stats.size

    req =
      Regex.run(
        ~r/bytes=([0-9]+)-([0-9]+)?/,
        conn |> Plug.Conn.get_req_header("range") |> List.first()
      )

    {req_start, _} = req |> Enum.at(1) |> Integer.parse()
    {req_end, _} = req |> Enum.at(2, filesize |> to_string) |> Integer.parse()

    Logger.debug("Serving #{path} from #{req_start} to #{req_end}")

    conn
    |> Plug.Conn.put_resp_header("Content-Type", "video/mp4")
    |> Plug.Conn.put_resp_header("Accept-Ranges", "bytes")
    |> Plug.Conn.put_resp_header(
      "Content-Range",
      "bytes #{req_start}-#{filesize - 1}/#{filesize}"
    )
    |> Plug.Conn.send_file(206, path, req_start, filesize - req_start)
  end
end

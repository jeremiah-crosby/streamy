defmodule Streamy.Folders.Sources.FilesystemSource do
  alias Streamy.Videos.Video

  @behaviour Streamy.Folders.FolderSource

  @video_extensions [".mp4", ".mpg", ".mpeg", ".flv", ".mkv", ".mov"]

  @impl Streamy.Folders.FolderSource
  @spec load_videos(String.t()) :: {:ok, list(%Video{})} | {:error, String.t()}
  def load_videos(name) do
    File.ls(name) |> process_file_list(name)
  end

  defp process_file_list({:error, reason}, _name) do
    {:error, "Unable to list files: #{reason}"}
  end

  defp process_file_list({:ok, files}, name) do
    groups =
      files
      |> Enum.map(&Path.join(name, &1))
      |> Enum.group_by(&File.dir?(&1))

    files =
      if groups[false] == nil do
        []
      else
        groups[false]
        |> Enum.filter(&video_file?/1)
        |> Enum.map(&to_video_struct/1)
      end

    files_in_subdirs =
      if groups[true] == nil do
        []
      else
        groups[true]
        |> Enum.flat_map(&load_videos(&1))
      end

    videos = Enum.concat(files, files_in_subdirs)

    {:ok, videos}
  end

  defp to_video_struct(file) do
    %Video{location: file, title: Path.basename(file)}
  end

  defp video_file?(file) do
    Enum.any?(@video_extensions, &(Path.extname(file) == &1))
  end
end

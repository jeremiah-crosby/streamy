import Config

# Configure the source for folders
config :streamy, Streamy.Folders.Scanner,
  source: Streamy.Folders.Sources.FilesystemSource,
  thumbnailer: Streamy.Videos.Thumbnails.ThumbnailerFilesystem,
  thumb_base_path: "./priv/static/video_thumbs"

# Configure repo implementations
config :streamy, Streamy.Folders, repo_impl: Streamy.Folders.FolderRepoEcto
config :streamy, Streamy.Videos, repo_impl: Streamy.Videos.VideoRepoEcto

case config_env() do
  :dev -> Code.require_file("runtime.dev.exs", "config")
  :prod -> Code.require_file("runtime.prod.exs", "config")
end

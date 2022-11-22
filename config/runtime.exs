import Config

# Configure repo implementations
config :streamy, Streamy.Folders, repo_impl: Streamy.Folders.FolderRepoEcto
config :streamy, Streamy.Videos, repo_impl: Streamy.Videos.VideoRepoEcto

cond do
  #
  # Dev config
  #
  config_env() == :dev ->
    # Configure the source for folders
    config :streamy, Streamy.Folders.Scanner,
      source: Streamy.Folders.Sources.FilesystemSource,
      thumbnailer: Streamy.Videos.Thumbnails.ThumbnailerFilesystem,
      thumb_base_path: "./priv/static/video_thumbs"

  #
  # Production config
  #
  config_env() == :prod ->
    streamy_config_path = Path.join(System.user_home!(), ".streamy")
    database_path = Path.join(streamy_config_path, "streamy.db")
    database_url = System.get_env("DATABASE_URL") || database_path
    IO.puts("database_url=#{database_url}")

    config :streamy, Streamy.Repo,
      # ssl: true,
      # socket_options: [:inet6],
      database: database_url,
      show_sensitive_data_on_connection_error: true

    # Configure the source for folders
    config :streamy, Streamy.Folders.Scanner,
      source: Streamy.Folders.Sources.FilesystemSource,
      thumbnailer: Streamy.Videos.Thumbnails.ThumbnailerFilesystem,
      thumb_base_path: Path.join(streamy_config_path, "video_thumbs")

    # The secret key base is used to sign/encrypt cookies and other secrets.
    # A default value is used in config/dev.exs and config/test.exs but you
    # want to use a different value for prod and you most likely don't want
    # to check this value into version control, so we use an environment
    # variable instead.
    secret_key_base =
      System.get_env("SECRET_KEY_BASE") ||
        "IfyqrNYJCktfLmx4gQAVTt9nzg+uPWOmtZv78DUI9qVYnWGdhus1+JxM/0YBm/cj"

    port = String.to_integer(System.get_env("PORT") || "4000")

    config :streamy, StreamyWeb.Endpoint,
      http: [
        # Enable IPv6 and bind on all interfaces.
        # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
        # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
        # for details about using IPv6 vs IPv4 and loopback vs public addresses.
        ip: {0, 0, 0, 0, 0, 0, 0, 0},
        port: port
      ],
      url: [host: "localhost", port: port],
      secret_key_base: secret_key_base

    # ## Using releases
    #
    # If you are doing OTP releases, you need to instruct Phoenix
    # to start each relevant endpoint:
    #
    config :streamy, StreamyWeb.Endpoint, server: true
    #
    # Then you can assemble a release by calling `mix release`.
    # See `mix help release` for more information.

    # ## Configuring the mailer
    #
    # In production you need to configure the mailer to use a different adapter.
    # Also, you may need to configure the Swoosh API client of your choice if you
    # are not using SMTP. Here is an example of the configuration:
    #
    #     config :streamy, Streamy.Mailer,
    #       adapter: Swoosh.Adapters.Mailgun,
    #       api_key: System.get_env("MAILGUN_API_KEY"),
    #       domain: System.get_env("MAILGUN_DOMAIN")
    #
    # For this example you need include a HTTP client required by Swoosh API client.
    # Swoosh supports Hackney and Finch out of the box:
    #
    #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
    #
    # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end

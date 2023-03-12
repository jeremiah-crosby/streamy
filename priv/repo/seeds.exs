# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Streamy.Repo.insert!(%Streamy.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Streamy.Repo.insert!(%Streamy.Playlists.Playlist{name: "Playlist1"})
Streamy.Repo.insert!(%Streamy.Playlists.Playlist{name: "Playlist2"})

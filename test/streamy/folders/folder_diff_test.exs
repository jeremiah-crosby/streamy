defmodule Streamy.Folders.FolderDiffTests do
  use ExUnit.Case

  alias Streamy.Videos.Video
  alias Streamy.Folders.FolderDiff

  describe "calculate_diff/2" do
    test "calculates videos to delete correctly" do
      repo_videos = [
        %Video{id: "123", location: "/opt/vids/1.mp4"},
        %Video{id: "234", location: "/opt/vids/2.mp4"},
        %Video{id: "345", location: "/opt/vids/3.mp4"}
      ]

      source_videos = [
        %Video{id: nil, location: "/opt/vids/1.mp4"},
        %Video{id: nil, location: "/opt/vids/2.mp4"}
      ]

      {videos_to_delete, videos_to_insert} = FolderDiff.calculate_diff(repo_videos, source_videos)

      assert([%Video{id: "345", location: "/opt/vids/3.mp4"}] == videos_to_delete)
      assert([] == videos_to_insert)
    end

    test "calculates videos to insert correctly" do
      repo_videos = [
        %Video{id: "123", location: "/opt/vids/1.mp4"},
        %Video{id: "234", location: "/opt/vids/2.mp4"},
        %Video{id: "345", location: "/opt/vids/3.mp4"}
      ]

      source_videos = [
        %Video{id: nil, location: "/opt/vids/1.mp4"},
        %Video{id: nil, location: "/opt/vids/2.mp4"},
        %Video{id: nil, location: "/opt/vids/3.mp4"},
        %Video{id: nil, location: "/opt/vids/4.mp4"},
        %Video{id: nil, location: "/opt/vids/5.mp4"}
      ]

      {videos_to_delete, videos_to_insert} = FolderDiff.calculate_diff(repo_videos, source_videos)

      assert(
        [
          %Video{id: nil, location: "/opt/vids/4.mp4"},
          %Video{id: nil, location: "/opt/vids/5.mp4"}
        ] == videos_to_insert
      )

      assert([] == videos_to_delete)
    end
  end
end

defmodule Streamy.PlayQueueTests do
  use ExUnit.Case
  alias Streamy.PlayQueue
  alias Streamy.Videos.Video
  import Double

  setup do
    fake_video_repo =
      Streamy.Videos.VideoRepo
      |> stub(:get_by_id, fn "1234" -> %Video{id: "1234", location: "/videos/1.mp4"} end)
      |> stub(:get_by_id, fn "2345" -> %Video{id: "2345", location: "/videos/2.mp4"} end)
      |> stub(:get_by_id, fn "3456" -> %Video{id: "3456", location: "/videos/3.mp4"} end)

    Application.put_env(:streamy, Streamy.Videos, repo_impl: fake_video_repo)

    PlayQueue.clear()
  end

  describe "move_next/0" do
    test "returns first video when at beginning" do
      PlayQueue.add_video("1234")
      PlayQueue.add_video("2345")
      PlayQueue.add_video("3456")

      assert {:ok, %Video{id: "1234", location: _}} = PlayQueue.move_next()
    end

    test "returns next video when in middle" do
      PlayQueue.add_video("1234")
      PlayQueue.add_video("2345")
      PlayQueue.add_video("3456")
      PlayQueue.move_next()

      assert {:ok, %Video{id: "2345", location: _}} = PlayQueue.move_next()
    end

    test "returns :empty when at end" do
      PlayQueue.add_video("1234")
      PlayQueue.add_video("2345")
      PlayQueue.add_video("3456")
      PlayQueue.move_next()
      PlayQueue.move_next()
      PlayQueue.move_next()

      assert :empty = PlayQueue.move_next()
    end

    test "return :empty for empty queue" do
      assert :empty = PlayQueue.move_next()
    end
  end

  describe "move_previous/0" do
    test "returns the last played video" do
      PlayQueue.add_video("1234")
      PlayQueue.add_video("2345")
      PlayQueue.add_video("3456")

      # Move to second video so moving back will return first video
      PlayQueue.move_next()
      PlayQueue.move_next()

      assert {:ok, %Video{id: "1234", location: _}} = PlayQueue.move_previous()
    end

    test "returns :empty if at beginning" do
      PlayQueue.add_video("1234")
      PlayQueue.add_video("2345")
      PlayQueue.add_video("3456")

      # Don't move so move_previous should return :empty

      assert :empty = PlayQueue.move_previous()
    end

    test "returns :empty if 1st video is playing" do
      PlayQueue.add_video("1234")
      PlayQueue.add_video("2345")
      PlayQueue.add_video("3456")

      PlayQueue.move_next()

      assert :empty = PlayQueue.move_previous()
    end

    test "returns :empty for empty queue" do
      # Don't add any videos to queue
      assert :empty = PlayQueue.move_previous()
    end
  end
end

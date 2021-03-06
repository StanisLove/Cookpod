defmodule CookpodWeb.ChatChannelTest do
  use CookpodWeb.ChannelCase
  import Cookpod.Factory

  setup do
    user = insert(:user)

    {:ok, _, socket} =
      socket(CookpodWeb.UserSocket, "socket_id", %{user_id: user.id})
      |> subscribe_and_join(CookpodWeb.ChatChannel, "chat:lobby:2")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to chat:lobby", %{socket: socket} do
    push(socket, "shout", %{"hello" => "all"})
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end

defmodule CookpodWeb.ChatChannel do
  @moduledoc false

  use CookpodWeb, :channel

  alias Cookpod.{Repo, User}

  def join("chat:" <> suffix, payload, socket) do
    [location, id] = String.split(suffix, ":")

    if authorized?(payload) do
      {:ok, %{channel: "chat:#{location}:#{id}"},
       Phoenix.Socket.assign(socket, location: location, id: id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("message:add", %{"message" => content}, socket) do
    %{location: location, id: id} = socket.assigns
    user = Repo.get(User, socket.assigns[:user_id])
    message = %{content: content, user: %{name: user.name || user.email}}
    broadcast!(socket, "chat:#{location}:#{id}:new_message", message)
    {:reply, :ok, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

defmodule CookpodWeb.ChatChannel do
  @moduledoc false

  use CookpodWeb, :channel

  require Logger

  def join("chat:lobby", payload, socket) do
    # {:ok, socket}
    if authorized?(payload) do
      {:ok, socket}
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
    broadcast!(socket, "chat:lobby:new_message", %{content: content})
    {:reply, :ok, socket}
  end

  def handle_in(any, payload, socket) do
    Logger.debug("Message from client: " <> inspect(any))
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

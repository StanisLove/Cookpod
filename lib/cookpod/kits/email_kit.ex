defmodule Cookpod.EmailKit do
  @moduledoc "Email helpers"

  @behaviour Cookpod.EmailKitBehaviour

  @doc ~S"""
  Check if the host of given email has mx record

  ## Examples

    iex> Cookpod.EmailKit.available?("random string")
    false

    iex> Cookpod.EmailKit.available?("test@im.sure.it.is.not.com")
    false

    iex> Cookpod.EmailKit.available?("test@gmail.com")
    true
  """
  @impl true
  def available?(email) do
    host = get_host(String.split(email, "@"))
    {result, _} = :inet_res.getbyname(to_charlist(host), :mx)
    result == :ok
  end

  defp get_host([_]), do: nil
  defp get_host([_, host]), do: host
end

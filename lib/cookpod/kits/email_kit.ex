defmodule Cookpod.EmailKit do
  @moduledoc "Email helpers"

  @doc ~S"""
  Check if the host of given email has mx record

  ## Examples

    iex> Cookpod.EmailKit.available?("test@gmail.com")
    true

    iex> Cookpod.EmailKit.available?("test@im.sure.it.is.not.com")
    false

    iex> Cookpod.EmailKit.available?("random string")
    false
  """
  @spec available?(String.t()) :: boolean()
  def available?(email) do
    host = get_host(String.split(email, "@"))
    {result, _} = :inet_res.getbyname(to_charlist(host), :mx)
    result == :ok
  end

  defp get_host([_]), do: nil
  defp get_host([_, host]), do: host
end

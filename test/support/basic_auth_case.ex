defmodule CookpodWeb.BasicAuthCase do
  @moduledoc """
  This module defines the test case to be used by
  controller tests with basic auth.
  """
  defmacro __using__(_) do
    quote do
      import Plug.Conn

      defp using_basic_auth(conn) do
        username = Application.get_env(:cookpod, :basic_auth)[:username]
        password = Application.get_env(:cookpod, :basic_auth)[:password]
        header_content = "Basic " <> Base.encode64("#{username}:#{password}")
        conn |> put_req_header("authorization", header_content)
      end
    end
  end
end

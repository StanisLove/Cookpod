defmodule CookpodWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use CookpodWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  import Cookpod.Factory
  import Plug.Conn
  import Plug.Test
  import Mock

  alias Ecto.Adapters.SQL.Sandbox

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias CookpodWeb.Router.Helpers, as: Routes
      import Plug.Test

      alias Cookpod.Repo
      import Ecto
      import Ecto.Query, only: [from: 2]
      import Plug.Conn

      defp count(query), do: Repo.count(query)

      import Cookpod.Factory

      use Cookpod.TmpCleaner

      # The default endpoint for testing
      @endpoint CookpodWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Cookpod.Repo)

    unless tags[:async] do
      Sandbox.mode(Cookpod.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    {conn, user} =
      if tags[:auth] do
        user = insert(:user)
        {conn |> init_test_session(user_id: user.id), user}
      else
        {conn, nil}
      end

    {:ok, conn: conn |> use_basic_auth, current_user: user}
  end

  defp use_basic_auth(conn) do
    username = Application.get_env(:cookpod, :basic_auth)[:username]
    password = Application.get_env(:cookpod, :basic_auth)[:password]
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end
end

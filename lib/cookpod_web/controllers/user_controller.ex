defmodule CookpodWeb.UserController do
  use CookpodWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end
end

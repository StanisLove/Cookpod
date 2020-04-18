defmodule CookpodWeb.PageController do
  use CookpodWeb, :controller

  plug CookpodWeb.Plugs.AuthPlug when action in [:terms]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def terms(conn, _params) do
    render(conn, "terms.html")
  end
end

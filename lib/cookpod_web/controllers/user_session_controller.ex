defmodule CookpodWeb.UserSessionController do
  use CookpodWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end

  # def create(conn, _params) do
  # end

  # def destroy(conn, _params) do
  # end
end

defmodule CookpodWeb.AuthConnCase do
  @moduledoc "Conn case with authorized user"

  defmacro __using__(_) do
    quote do
      use CookpodWeb.ConnCase

      @moduletag :auth
    end
  end
end

defmodule CookpodWeb.IntegrationCase do
  @moduledoc "Case for integration tests"

  use ExUnit.CaseTemplate

  using do
    quote do
      use CookpodWeb.ConnCase
      use PhoenixIntegration
    end
  end
end

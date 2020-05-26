defmodule Cookpod.Mocks.EmailKit do
  @moduledoc "Mock for EmailKit"

  defmacro __using__(_) do
    quote do
      alias Cookpod.EmailKit
      import Mock

      setup_with_mocks([
        {EmailKit, [], available?: fn _ -> true end}
      ]) do
        :ok
      end
    end
  end
end

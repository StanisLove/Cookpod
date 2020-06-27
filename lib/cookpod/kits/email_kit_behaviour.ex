defmodule Cookpod.EmailKitBehaviour do
  @moduledoc false

  @callback available?(String.t()) :: boolean()
end

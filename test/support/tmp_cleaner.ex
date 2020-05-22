defmodule Cookpod.TmpCleaner do
  @moduledoc "Use it to remove test folder in tmp"

  defmacro __using__(_) do
    quote do
      setup_all do
        on_exit(:clear_tmp, fn ->
          File.rm_rf!("tmp/test")
        end)
      end
    end
  end
end

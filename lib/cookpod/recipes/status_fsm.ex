defmodule Cookpod.Recipes.StatusFsm do
  @moduledoc false
  use Fsm, initial_state: :draft

  def error_state, do: :not_permitted

  defstate draft do
    defevent(publish, do: next_state(:published))
  end

  defstate published do
    defevent(archive, do: next_state(:archived))
  end

  defevent(_, do: next_state(error_state()))
end

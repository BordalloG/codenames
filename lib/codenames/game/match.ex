defmodule Codenames.Game.Match do
  @moduledoc """
    Match is the module responsible for handling the match state
  """
  alias Codenames.Game.Player
  alias Codenames.Game.Board

  @type t :: %__MODULE__{
          id: integer(),
          board: Board.t(),
          teams: %{orange: list(Player.t()), blue: list(Player.t())}
        }

  defstruct [:id, :board, teams: %{orange: [], blue: []}]
end

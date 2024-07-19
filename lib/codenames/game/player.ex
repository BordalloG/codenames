defmodule Codenames.Game.Player do
@moduledoc """
 The player module represents a player in a match
 The player can assume one of two roles in the game operative or spymaster
"""

  @type t :: %__MODULE__{
    id: integer(),
    nick: String.t(),
    role: :operative | :spymaster
  }

  defstruct [:id, :nick, :role]
end

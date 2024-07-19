defmodule Codenames.Game.Card do
  @moduledoc """
    A card is the smallest piece of this game, is used to display a word.
    The card can be from a team, having its color as blue or orange, or also from no team, having its color as white or black.
  """
  @type t :: %__MODULE__{
          word: String.t(),
          color: :blue | :orange | :white | :black,
          status: :hidden | :revealed
        }

  defstruct [:word, :color, status: :hidden]
end

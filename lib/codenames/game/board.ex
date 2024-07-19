defmodule Codenames.Game.Board do
  @moduledoc """
    A Board carries 25 cards
  """
  alias Codenames.Game.Card

  @type t :: %__MODULE__{
          cards: list(Card.t())
        }

  defstruct cards: []
end

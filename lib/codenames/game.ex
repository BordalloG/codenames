defmodule Codenames.Game do
  @moduledoc """
    Game carries a set of functions used to create and run a game
  """
  alias Codenames.Game.Card
  alias Codenames.Game.Board
  alias Codenames.Game.Match

  @cards_amount 25

  @spec new_match() :: Match.t()
  def new_match() do
    %Match{id: System.unique_integer([:positive]), board: new_board(), teams: %{orange: [], blue: []}}
  end

  @spec new_board() :: Board.t()
  def new_board() do
    cards =
      fetch_words(@cards_amount)
      |> Enum.with_index()
      |> Enum.map(fn {word, index} ->
        cond do
          index < 9 -> %Card{word: word, color: :orange, status: :hidden}
          index < 17 -> %Card{word: word, color: :blue, status: :hidden}
          index < 24 -> %Card{word: word, color: :white, status: :hidden}
          index == 24 -> %Card{word: word, color: :black, status: :hidden}
        end
      end)

    %Board{cards: cards}
  end

  @spec fetch_words(integer()) :: list(String.t())
  def fetch_words(amount) do
    [File.cwd!(), "priv", "data", "words.txt"]
    |> Path.join()
    |> File.read!()
    |> String.split("\n")
    |> Enum.shuffle()
    |> Enum.slice(0..(amount - 1))
  end

end

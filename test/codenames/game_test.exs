defmodule Codenames.GameTest do
  alias Codenames.Game.Match
  alias Codenames.Game.Board

  use Codenames.DataCase
  use ExUnit.Case, async: true

  describe "match" do
    test "new_match" do
      assert %Match{} = Codenames.Game.new_match()
    end
  end

  describe "board" do
    test "new_board/0 creating a new board should return a board with 25 hidden cards with the correct color distribution" do
      assert %Board{} = board = Codenames.Game.new_board()
      assert length(board.cards) == 25
      assert length(Enum.filter(board.cards, fn card -> card.color == :orange end)) == 9
      assert length(Enum.filter(board.cards, fn card -> card.color == :blue end)) == 8
      assert length(Enum.filter(board.cards, fn card -> card.color == :white end)) == 7
      assert length(Enum.filter(board.cards, fn card -> card.color == :black end)) == 1
    end

    test "fetch_words/1 should return a list of different words" do
      assert [word1, word2] = Codenames.Game.fetch_words(2)
      assert word1 != word2

      list_words_1 = Codenames.Game.fetch_words(100)
      list_words_2 = Codenames.Game.fetch_words(100)
      assert list_words_1 != list_words_2
    end
  end
end

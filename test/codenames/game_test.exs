defmodule Codenames.GameTest do
  alias Codenames.Game.Match
  alias Codenames.Game.Board

  use Codenames.DataCase
  use ExUnit.Case, async: true

  import Codenames.GameFixtures

  describe "match" do
    test "new_match" do
      assert %Match{} = Codenames.Game.new_match()
    end
  end

  describe "join/2 and join/3" do
    test "join/3 should return match with the given player in the given team" do
      blue_player = player_fixture()
      orange_player = player_fixture()

      match =
        Codenames.Game.new_match()
        |> Codenames.Game.join(blue_player, :blue)
        |> Codenames.Game.join(orange_player, :orange)

      assert match.teams.blue == [blue_player]
      assert match.teams.orange == [orange_player]
    end

    test "join/2 should return match with a player in the team with " do
      player = player_fixture()
      player2 = player_fixture()
      player3 = player_fixture()

      match =
        Codenames.Game.new_match()
        |> Codenames.Game.join(player)

      assert match.teams.orange == [player]

      match = Codenames.Game.join(match, player2)

      assert match.teams.orange == [player]
      assert match.teams.blue == [player2]

      match = Codenames.Game.join(match, player3)

      assert Enum.member?(match.teams.orange, player)
      assert Enum.member?(match.teams.orange, player3)

      assert match.teams.blue == [player2]
    end

    test "join/2 same player should not join twice" do
      player = player_fixture()

      match =
        Codenames.Game.new_match()
        |> Codenames.Game.join(player)
        |> Codenames.Game.join(player)

      assert match.teams.orange == [player]
      assert match.teams.blue == []
    end
  end

  describe "leave/2" do
    test "leave/2 should remove player no matter the team he is" do
      player = player_fixture()

      match =
        Codenames.Game.new_match()
        |> Codenames.Game.join(player)
        |> Codenames.Game.leave(player)

      assert length(match.teams.blue) == 0
      assert length(match.teams.orange) == 0
    end

    test "leave/2 should remove the correct player" do
      player = player_fixture()
      player2 = player_fixture()

      match =
        Codenames.Game.new_match()
        |> Codenames.Game.join(player)
        |> Codenames.Game.join(player2)
        |> Codenames.Game.leave(player)

      assert match.teams.blue == [player2]
      assert length(match.teams.orange) == 0
    end

    test "should not remove anyone if a player that isn't in the match leaves" do
      player = player_fixture()
      player2 = player_fixture()

      match =
        Codenames.Game.new_match()
        |> Codenames.Game.join(player)
        |> Codenames.Game.leave(player2)

      assert match.teams.blue == []
      assert match.teams.orange == [player]
    end
  end

  describe "change_team/3 and change_team/2" do
    test "player in team orange should change to blue team" do
      player = player_fixture()

      match =
        Codenames.Game.new_match()
        |> Codenames.Game.join(player)
        |> Codenames.Game.change_team(player)

      assert match.teams.blue == [player]

      match = Codenames.Game.change_team(match, player)

      assert match.teams.orange == [player]
    end
  end

  describe "chage_role/2" do
    test "should switch current player role and not affect other users" do
      player = player_fixture()
      player2 = player_fixture()

      match =
        Codenames.Game.new_match()
        |> Codenames.Game.join(player)
        |> Codenames.Game.join(player2)
        |> Codenames.Game.join(player_fixture())

      assert Enum.find(match.teams.orange, fn p -> p.id == player.id end)[:role] == :operative
      assert Enum.find(match.teams.blue, fn p -> p.id == player2.id end)[:role] == :operative

      match = Codenames.Game.change_role(match, player)

      assert Enum.find(match.teams.orange, fn p -> p.id == player.id end)[:role] == :spymaster
      assert Enum.find(match.teams.blue, fn p -> p.id == player2.id end)[:role] == :operative
    end
  end

  describe "find_player/2" do
    test "should return the correct player with correct team" do
      player = player_fixture()

      assert {:ok, {^player, :orange}} =
               Codenames.Game.new_match()
               |> Codenames.Game.join(player)
               |> Codenames.Game.find_player(player.id)
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

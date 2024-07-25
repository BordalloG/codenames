defmodule Codenames.Game do
  @moduledoc """
    Game carries a set of functions used to create and run a game
  """
  alias Codenames.Game.Player
  alias Codenames.Game.Card
  alias Codenames.Game.Board
  alias Codenames.Game.Match

  @cards_amount 25

  @spec join(Match.t(), Player.t()) :: Match.t()
  def join(match, player) do
    orange = players_in_team(match, :orange)
    blue = players_in_team(match, :blue)

    cond do
      Enum.member?(orange, player) -> match
      Enum.member?(blue, player) -> match
      length(orange) > length(blue) -> join(match, player, :blue)
      true -> join(match, player, :orange)
    end
  end

  @spec join(Match.t(), Player.t(), :blue) :: Match.t()
  def join(match, player, :blue) do
    blue = [player | match.teams.blue]
    teams = %{match.teams | blue: blue}
    %{match | teams: teams}
  end

  @spec join(Match.t(), Player.t(), :orange) :: Match.t()
  def join(match, player, :orange) do
    orange = [player | match.teams.orange]
    teams = %{match.teams | orange: orange}
    %{match | teams: teams}
  end

  @spec leave(Match.t(), Player.t()) :: Match.t()
  def leave(match, player) do
    match
    |> remove_from_team(player, :orange)
    |> remove_from_team(player, :blue)
  end

  @spec players_in_team(Match.t(), :orange | :blue) :: list(Player.t())
  def players_in_team(match, team) do
    Map.get(match.teams, team)
  end

  @spec change_team(Match.t(), Player.t()) :: Match.t()
  def change_team(match, player) do
    team = find_team(match, player)
    change_team(match, player, team)
  end

  @spec change_team(Match.t(), Player.t(), :blue | :orange) :: Match.t()
  def change_team(match, _player, nil) do
    match
  end

  def change_team(match, player, team) do
    match
    |> remove_from_team(player, team)
    |> join(player, opposite_team(team))
  end

  @spec find_team(Match.t(), Player.t()) :: :blue | :orange
  def find_team(match, player) do
    cond do
      Enum.find(match.teams.blue, nil, fn p -> p == player end) == player -> :blue
      Enum.find(match.teams.orange, nil, fn p -> p == player end) == player -> :orange
      true -> nil
    end
  end

  @spec remove_from_team(Match.t(), Player.t(), :orange | :blue) :: Match.t()
  defp remove_from_team(match, player, :blue) do
    blue = Enum.reject(match.teams.blue, fn p -> p.id == player.id end)
    teams = %{match.teams | blue: blue}
    %{match | teams: teams}
  end

  defp remove_from_team(match, player, :orange) do
    orange = Enum.reject(match.teams.orange, fn p -> p.id == player.id end)
    teams = %{match.teams | orange: orange}
    %{match | teams: teams}
  end

  @spec change_role(Match.t(), Player.t()) :: Match.t()
  def change_role(match, player) do
    team = find_team(match, player)

    players =
      Enum.map(players_in_team(match, team), fn p ->
        if player == p do
          %{p | role: opposite_role(p.role)}
        else
          p
        end
      end)

    teams =
      case team do
        :orange -> %{match.teams | orange: players}
        :blue -> %{match.teams | blue: players}
      end

    %{match | teams: teams}
  end

  @spec find_player(Match.t(), String.t()) :: {:ok, {Player.t(), :orange | :blue}} | nil
  def find_player(match, player_id) do
    blue = Enum.find(match.teams.blue, nil, fn player -> player.id == player_id end)
    orange = Enum.find(match.teams.orange, nil, fn player -> player.id == player_id end)

    cond do
      blue != nil -> {:ok, {blue, :blue}}
      orange != nil -> {:ok, {orange, :orange}}
      true -> nil
    end
  end

  @spec new_match() :: Match.t()
  def new_match() do
    %Match{
      id: System.unique_integer([:positive]),
      board: new_board(),
      teams: %{orange: [], blue: []}
    }
  end

  @spec opposite_team(:blue | :orange) :: :blue | :orange
  defp opposite_team(:blue), do: :orange
  defp opposite_team(:orange), do: :blue

  @spec opposite_role(:spymaster | :operative) :: :spymaster | :operative
  defp opposite_role(:spymaster), do: :operative
  defp opposite_role(:operative), do: :spymaster

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
      |> Enum.shuffle()

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

defmodule Codenames.Server.ClientTest do
  use Codenames.DataCase
  use ExUnit.Case, async: true

  import Codenames.GameFixtures

  alias Codenames.Server.Client

  defp create_server(_) do
    {:ok, match} = Codenames.Server.Supervisor.start_match_server()
    %{match: match}
  end

  describe "state/1" do
    setup [:create_server]

    test "should return the match state", %{match: match} do
      assert match == Client.state(match.id)
    end

    test "should return match not found when match doesn't exist" do
      assert {:error, :match_not_found} == Client.state("fake id")
    end
  end

  describe "join/2" do
    setup [:create_server]

    test "should join a player in the match", %{match: match} do
      match = Client.join(match.id, player_fixture())

      assert length(Codenames.Game.players_in_team(match, :orange)) == 1

      match = Client.join(match.id, player_fixture())

      assert length(Codenames.Game.players_in_team(match, :blue)) == 1
    end
  end

  describe "change_team/2" do
    setup [:create_server]

    test "should change player to the opposite team", %{match: match} do
      player = player_fixture()
      Client.join(match.id, player)

      match = Client.state(match.id)

      assert match.teams.blue == []
      assert match.teams.orange == [player]

      Client.change_team(match.id, player)

      match = Client.state(match.id)
      assert match.teams.blue == [player]
      assert match.teams.orange == []
    end
  end

  describe "change_role/2" do
    setup [:create_server]

    test "should change player role", %{match: match} do
      player = player_fixture()

      Client.join(match.id, player)
      Client.change_role(match.id, player)

      match = Client.state(match.id)

      assert hd(match.teams.orange)[:role] != player[:role]
    end
  end
end

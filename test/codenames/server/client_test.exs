defmodule Codenames.Server.ClientTest do
  use Codenames.DataCase
  use ExUnit.Case, async: true

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
end

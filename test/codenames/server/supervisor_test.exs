defmodule Codenames.Server.SupervisorTest do
  alias Codenames.Game.Match
  use Codenames.DataCase
  use ExUnit.Case, async: true

  describe "start_match_server/0" do
    test "should create a new server and return the match" do
      {:ok, %Match{} = _match} = Codenames.Server.Supervisor.start_match_server()
    end
  end
end

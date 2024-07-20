defmodule Codenames.Server.ServerNameTest do
  use ExUnit.Case
  alias Codenames.Server.ServerName

  describe "put_match_pid/2" do
    test "successfully inserts a match ID and PID into the ETS table" do
      match_id = "match_123"
      pid = self()
      assert ServerName.put_match_pid(match_id, pid) == true
    end
  end

  describe "get_match_pid/1" do
    test "retrieves the PID for a given match ID" do
      match_id = "match_123"
      pid = self()
      ServerName.put_match_pid(match_id, pid)
      assert ServerName.get_match_pid(match_id) == {:ok, pid}
    end

    test "returns :error if the match ID does not exist" do
      assert ServerName.get_match_pid("nonexistent_match") == :error
    end
  end

  describe "remove_match_pid/1" do
    test "successfully removes a match ID and its associated PID from the ETS table" do
      match_id = "match_123"
      pid = self()
      ServerName.put_match_pid(match_id, pid)
      assert ServerName.remove_match_pid(match_id) == true
      assert ServerName.get_match_pid(match_id) == :error
    end
  end
end

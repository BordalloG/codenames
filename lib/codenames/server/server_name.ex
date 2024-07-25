defmodule Codenames.Server.ServerName do
  @moduledoc """
      An interface over ETS to store and restore match_id and PIDs
  """
  @table_name :server_name

  @spec put_match_pid(String.t() | integer(), pid()) :: true
  def put_match_pid(match_id, pid) do
    :ets.insert(@table_name, {to_string(match_id), pid})
  end

  @spec get_match_pid(String.t() | integer()) :: {atom(), pid()} | :error
  def get_match_pid(match_id) do
    match_id = to_string(match_id)

    case :ets.lookup(@table_name, match_id) do
      [{^match_id, pid}] -> {:ok, pid}
      _ -> :error
    end
  end

  @spec remove_match_pid(String.t() | integer()) :: boolean()
  def remove_match_pid(match_id) do
    :ets.delete(@table_name, to_string(match_id))
  end
end

defmodule Codenames.Server.Client do
  @moduledoc """
    Provides an interface for calling or casting messages to Codenames.Server
  """
alias Codenames.Server.ServerName
alias Codenames.Game.Match

  @spec state(String.t()) :: Match.t() | {:error, :match_not_found}
  def state(match_id) do
    call_with_match_id(match_id, :state)
  end

  @spec call_with_match_id(String.t(), any()) ::  any() | {:error, :match_not_found}
  defp call_with_match_id(match_id, message) do
    case ServerName.get_match_pid(match_id) do
      {:ok, pid} -> GenServer.call(pid, message)
      _ -> {:error, :match_not_found}
    end
  end
end

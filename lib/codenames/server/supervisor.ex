defmodule Codenames.Server.Supervisor do
  @moduledoc """
      Supervisor responsible for creating and killing matchs
  """
alias Codenames.Game.Match
alias Codenames.Server.ServerName
alias Codenames.Server

  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec start_match_server() :: {:ok, Match.t()} | {:error, term()}
  def start_match_server() do
    spec = {Server, %{}}
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, spec)

    case GenServer.call(pid, :state) do
      %Match{} = match ->
        ServerName.put_match_pid(match.id, pid)
        {:ok, match}

      term ->
        {:error, term}
    end
  end
end

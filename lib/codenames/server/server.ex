defmodule Codenames.Server do
@moduledoc """
 Genserver responsible to manage a Match
"""
alias Codenames.Game.Match

use GenServer

  def init(_) do
    match = Codenames.Game.new_match()
    {:ok, match}
  end

  @spec start_link(Match.t()) :: atom
  def start_link(match) do
    GenServer.start_link(__MODULE__, match)
  end

  @spec handle_call(:state, {pid, term()}, Match.t()) :: {:reply, Match.t(), Match.t()}
  def handle_call(:state, _from, %Match{} = match) do
    {:reply, match, match}
  end
end

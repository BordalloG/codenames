defmodule Codenames.Server do
  @moduledoc """
   Genserver responsible to manage a Match
  """
  require Logger
  alias Codenames.Game.Player
  alias Codenames.Game.Match

  use GenServer

  def init(_) do
    match = Codenames.Game.new_match()
    Phoenix.PubSub.subscribe(Codenames.PubSub, CodenamesWeb.Presence.presence_topic(match.id))
    {:ok, match}
  end

  @spec start_link(Match.t()) :: atom
  def start_link(match) do
    GenServer.start_link(__MODULE__, match)
  end

  @spec terminate(atom(), Match) :: any()
  def terminate(reason, state) do
    Logger.info("Match #{state.id} has exit with reason #{inspect(reason)}")
    Codenames.Server.ServerName.remove_match_pid(state.id)
  end

  @spec handle_call(:state, {pid(), term()}, Match.t()) :: {:reply, Match.t(), Match.t()}
  def handle_call(:state, _from, %Match{} = match) do
    {:reply, match, match}
  end

  @spec handle_call({:join, Player.t()}, {pid(), term()}, Match.t()) ::
          {:reply, Match.t(), Match.t()}
  def handle_call({:join, player}, _from, state) do
    match =
      Codenames.Game.join(state, player)
      |> Codenames.PubSub.broadcast_match_update()

    {:reply, match, match}
  end

  @spec handle_call({:change_team, Player.t()}, {pid(), term()}, Match.t()) ::
          {:reply, Match.t(), Match.t()}
  def handle_call({:change_team, player}, _from, state) do
    match =
      state
      |> Codenames.Game.change_team(player)
      |> Codenames.PubSub.broadcast_match_update()

    {:reply, match, match}
  end

  @spec handle_call({:change_role, Player.t()}, {pid(), term()}, Match.t()) ::
          {:reply, Match.t(), Match.t()}
  def handle_call({:change_role, player}, _from, state) do
    match =
      state
      |> Codenames.Game.change_role(player)
      |> Codenames.PubSub.broadcast_match_update()

    {:reply, match, match}
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{
          event: "presence_diff",
          payload: %{joins: _joins, leaves: leaves}
        },
        state
      ) do
    match =
      Enum.reduce(leaves, state, fn {_id, %{metas: [user | _]}}, acc ->
        Codenames.Game.leave(acc, user)
      end)
      |> Codenames.PubSub.broadcast_match_update()

    {:noreply, match}
  end
end

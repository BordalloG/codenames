defmodule CodenamesWeb.MatchLive.Show do
  alias Codenames.Game.Match
  alias Codenames.Server.Client
  import CodenamesWeb.MatchComponents

  use CodenamesWeb, :live_view

  def mount(%{"id" => match_id}, %{"current_player" => player}, socket) do
    case Client.state(match_id) do
      {:error, :match_not_found} ->
        socket =
          socket
          |> put_flash(
            :error,
            "The match you tried to join doesn't exist, we are going to create a new one for you!"
          )
          |> push_navigate(to: ~p"/match/new")

        {:ok, socket}

      %Match{} = match ->
        match = Client.join(match.id, player)
        Phoenix.PubSub.subscribe(Codenames.PubSub, Codenames.PubSub.match_topic(match.id))
        CodenamesWeb.Presence.track_user(self(), match.id, player)
        {:ok, assign(socket, :match, match), layout: false}
    end
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "update", payload: match}, socket) do
    socket =
      socket
      |> maybe_update_player(match)
      |> assign(:match, match)

    {:noreply, socket}
  end

  def handle_event("change-team", _unsigned_params, socket) do
    Client.change_team(socket.assigns.match.id, socket.assigns.current_player)
    {:noreply, socket}
  end

  def handle_event("change-role", _unsigned_params, socket) do
    Client.change_role(socket.assigns.match.id, socket.assigns.current_player)
    {:noreply, socket}
  end

  defp maybe_update_player(socket, match) do
    {:ok, {player, _team}} = Codenames.Game.find_player(match, socket.assigns.current_player.id)

    assign(socket, :current_player, player)
  end
end

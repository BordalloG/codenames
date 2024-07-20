defmodule CodenamesWeb.MatchLive.Show do

  alias Codenames.Game.Match
  alias Codenames.Server.Client
  use CodenamesWeb, :live_view

  def handle_params(%{"id" => match_id}, _url, socket) do
    case Client.state(match_id) do
      {:error, :match_not_found} ->
        socket =
          socket
          |> put_flash(:error, "The match you tried to join doesn't exist, we are going to create a new one for you!")
          |> push_navigate(to: ~p"/match/new")
        {:noreply, socket}
      %Match{} =  match ->
        {:noreply, assign(socket, :match, match)}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end
end

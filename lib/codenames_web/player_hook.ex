defmodule CodenamesWeb.PlayerHook do
  @moduledoc """
    Hook to assign player to socket or redirect to set up player
  """

  def on_mount(:ensure_player, _params, %{"current_player" => player}, socket) do
    {:cont, Phoenix.Component.assign(socket, :current_player, player)}
  end

  def on_mount(:ensure_player, %{"id" => id}, _session, socket) do
    socket =
      socket
      |> Phoenix.LiveView.redirect(to: "/player/new?return_to=/match/#{id}")
      |> Phoenix.LiveView.put_flash(:error, "You need to pick a nick to play")

    {:halt, socket}
  end
end

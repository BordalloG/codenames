defmodule CodenamesWeb.MatchLive.New do
  use CodenamesWeb, :live_view

  alias Codenames.Server

  def mount(_params, _session, socket) do
    {:ok, match} = Server.Supervisor.start_match_server()
    socket =
      socket
      |> put_flash(:info, "New match created!")
      |> push_navigate(to: ~p"/match/#{match.id}")

    {:ok, socket, layout: false}
  end
end

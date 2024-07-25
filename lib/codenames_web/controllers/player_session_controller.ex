defmodule CodenamesWeb.PlayerSessionController do
  use CodenamesWeb, :controller

  def create(conn, %{"player" => %{"nick" => nick}} = params) do
    return_to = params["return_to"]

    conn
    |> put_session(:current_player, %Codenames.Game.Player{
      id: UUID.uuid4(),
      nick: nick,
      role: :operative
    })
    |> redirect(to: return_to || "/")
  end
end

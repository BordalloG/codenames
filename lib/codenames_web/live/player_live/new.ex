defmodule CodenamesWeb.PlayerLive.New do
  use CodenamesWeb, :live_view

  def handle_params(params, _uri, socket) do
    {:noreply, assign(socket, return_to: params["return_to"])}
  end

  def render(assigns) do
    ~H"""
    <.live_component
      module={CodenamesWeb.PlayerLive.FormComponent}
      id="player_form"
      return_to={@return_to}
    />
    """
  end
end

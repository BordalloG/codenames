defmodule CodenamesWeb.PlayerLive.FormComponent do
  use CodenamesWeb, :live_component

  alias Codenames.Game.Player

  def mount(socket) do
    changeset = Player.changeset(%Player{}, %{})
    {:ok, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "player")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  def handle_event("validate", %{"player" => params}, socket) do
    changeset = Player.changeset(%Player{}, params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="player_form"
        phx-target={@myself}
        phx-change="validate"
        action={ "/player/new" <> if @return_to == nil do "" else "?return_to=" <> @return_to end}
      >
        <.input field={@form[:nick]} type="text" label="Nick" />
        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end

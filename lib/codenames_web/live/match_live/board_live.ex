defmodule CodenamesWeb.Match.BoardLive do
  use CodenamesWeb, :live_component

  import CodenamesWeb.MatchComponents
  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="grid grid-cols-5 grid-rows-5 gap-y-5 gap-x-0 w-4/5">
        <.card :for={card <- @board.cards} word={card.word} status={card.status} color={card.color}/>
      </div>
    """
  end
end

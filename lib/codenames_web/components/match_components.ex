defmodule CodenamesWeb.MatchComponents do
  @moduledoc """
  Provides UI components for the match.
  """
  use Phoenix.Component

  @doc """
    Renders a card.
    The final render will be defined by a combination of factors, like if the card is hidden, or the type of player seeing the card
  """
  attr :word, :string, required: true
  attr :status, :atom, required: true
  attr :color, :atom, required: true
  attr :current_player, :map, required: true

  def card(assigns) do
    ~H"""
    <div class={[
      "flex justify-center items-center border-2 rounded w-48 h-20 shadow-lg",
      @status == :hidden && @current_player.role == :operative && "bg-slate-200 border-slate-400",
      @color == :blue && "bg-blue-200 border-blue-400",
      @color == :orange && "bg-orange-200 border-orange-400",
      @color == :black && "bg-gray-700 border-gray-950",
      @color == :white && "bg-gray-200 border-gray-400"
    ]}>
      <%= @word %>
    </div>
    """
  end

  def team(assigns) do
    ~H"""
    <div class={[
      "flex flex-col p-4 rounded h-1/3 w-40 mt-20 self-start",
      @color == :orange && "bg-orange-200",
      @color == :blue && "bg-blue-200"
    ]}>
      <div class="h-1/5 text-center">
        <%= @color %> team
      </div>
      <div class="h-3/5 flex flex-col items-center">
        Spymaster:
        <ul>
          <li :for={spy <- Enum.filter(@players, fn player -> player.role == :spymaster end)}>
            <span class="py-1 px-2 text-sm font-bold border border-black rounded">
              <%= spy.nick %>
            </span>
          </li>
        </ul>
        Operators:
        <ul>
          <li :for={operative <- Enum.filter(@players, fn player -> player.role == :operative end)}>
            <%= operative.nick %>
          </li>
        </ul>
      </div>
      <div class="flex justify-center">
        <button
          :if={!Enum.member?(@players, @current_player)}
          phx-click="change-team"
          class="bg-neutral-950 text-white text-sm py-4 px-2 rounded shadow-lg"
        >
          Join this team
        </button>
        <button
          :if={Enum.member?(@players, @current_player)}
          phx-click="change-role"
          class="border border-black rounded"
        >
          switch role
        </button>
      </div>
    </div>
    """
  end
end

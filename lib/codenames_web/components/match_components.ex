defmodule CodenamesWeb.MatchComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component

  @doc """
    Renders a card
  """
  attr :word, :string, required: true
  attr :status, :atom, required: true
  attr :color, :atom, required: true
  def card(assigns) do
    ~H"""
      <div
        class={["flex justify-center items-center border-2 rounded w-48 h-20 shadow-lg",
          @status == :hidden && "bg-slate-200 border-slate-400 cursor-pointer",
          @status == :revealed && @color == :blue && "bg-blue-200 border-blue-400",
          @status == :revealed && @color == :orange && "bg-orange-200 border-orange-400",
          @status == :revealed && @color == :black && "text-white bg-gray-700 border-gray-950",
          @status == :revealed && @color == :white && "bg-gray-200 border-gray-400"]}>
         <%= @word %>
         <%= @color %>
      </div>
    """
  end
end

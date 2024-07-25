defmodule Codenames.PubSub do
  @moduledoc """
      Simplify and standardize Pub Sub activities
  """
  alias Codenames.Game.Match

  @spec match_topic(String.t() | integer()) :: String.t()
  def match_topic(match_id) do
    "match:" <> to_string(match_id)
  end

  @spec broadcast_match_update(Match.t()) :: Match.t() | {:error, term()}
  def broadcast_match_update(match) do
    case Phoenix.PubSub.broadcast(
           Codenames.PubSub,
           match_topic(match.id),
           %Phoenix.Socket.Broadcast{
             topic: match_topic(match.id),
             event: "update",
             payload: match
           }
         ) do
      :ok -> match
      {:error, reason} -> {:error, reason}
    end
  end
end

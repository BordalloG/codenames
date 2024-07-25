defmodule CodenamesWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :codenames,
    pubsub_server: Codenames.PubSub

  @match_topic_prefix "presence:"

  @spec presence_topic(String.t()) :: String.t()
  def presence_topic(match_id) do
    @match_topic_prefix <> Codenames.PubSub.match_topic(match_id)
  end

  def track_user(socket_pid, match_id, user) do
    track(socket_pid, presence_topic(match_id), user.id, user)
  end

  @spec list_users(String.t()) :: list()
  def list_users(match_id) do
    list(presence_topic(match_id))
  end
end

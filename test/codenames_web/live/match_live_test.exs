defmodule Codenames.MatchLiveTest do
  alias Codenames.Server.Supervisor
  alias Codenames.Game.Match
  alias Codenames.Server.Client
  use CodenamesWeb.ConnCase

  import Phoenix.LiveViewTest

  defp create_player(%{conn: conn}) do
    conn = set_up_player(conn, "Player 1")
    %{conn: conn}
  end

  describe "New" do
    setup [:create_player]

    test "creates a new match and redirects", %{conn: conn} do
      assert {:error,
              {:live_redirect, %{to: "/match/" <> id, flash: %{"info" => "New match created!"}}}} =
               live(conn, ~p"/match/new")

      assert {_parsed_id, ""} = Integer.parse(id)
      assert %Match{} = match = Client.state(id)
      assert to_string(match.id) == id
    end
  end

  describe "Show" do
    setup [:create_player]

    test "show should have match state, render all cards, teams and players", %{conn: conn} do
      {:ok, match} = Supervisor.start_match_server()
      {:ok, index_live, _html} = live(conn, ~p"/match/#{match.id}")

      html = render(index_live)

      Enum.map(match.board.cards, fn card ->
        assert html =~ card.word
      end)

      # both teams are rendered
      assert html =~ "orange team"
      assert html =~ "blue team"
      # current player is rendered
      assert html =~ "Player 1"
      # change team button is renderd
      assert html =~ "Join this team"
    end

    test "show should redirect to /match/new when given id doesn't exist", %{conn: conn} do
      assert {:error,
              {:live_redirect,
               %{
                 to: "/match/new",
                 flash: %{
                   "error" =>
                     "The match you tried to join doesn't exist, we are going to create a new one for you!"
                 }
               }}} = live(conn, ~p"/match/fake_id")
    end

    test "should change current player team when clicking the join team button", %{conn: conn} do
      {:ok, match} = Supervisor.start_match_server()
      {:ok, index_live, _html} = live(conn, ~p"/match/#{match.id}")

      index_live
      |> element("button", "Join this team")
      |> render_click()
    end
  end
end

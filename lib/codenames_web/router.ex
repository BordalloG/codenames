defmodule CodenamesWeb.Router do
  use CodenamesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CodenamesWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CodenamesWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/player/new", PlayerLive.New
    post "/player/new", PlayerSessionController, :create
  end

  scope "/match", CodenamesWeb do
    pipe_through [:browser]

    live_session :match_session,
      on_mount: [{CodenamesWeb.PlayerHook, :ensure_player}] do
      live "/new", MatchLive.New
      live "/:id", MatchLive.Show
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", CodenamesWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:codenames, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CodenamesWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

# Codenames
#### An Elixir/Phoenix implementation of the game Codenames originally designed by Vlaada Chvátil and published by Czech Games Edition

** *The project is not finished, thefore the game is not fully playable yet.*


## How does it work?
![Codenames](https://github.com/user-attachments/assets/9bb633d8-971d-4b6d-86be-846c4abe4179)
*big picture diagram*

When a new match is requested, the Dynamic Supervisor spawns a new GenServer(2), which will hold the match state and handle messages that make the game happen.  
During the initialization of this GenServer the initial data will be created(3) and it will subscribe to a presence PubSub(4), this will be used to track which users are on the match.  
Once the supervisor has the GenServer PID, it requests from the server its current state(5) to get the match id, which is saved on an ETS table (6).  
Finally, the match state is returned to whoever requested a new Match (7)
![image](https://github.com/user-attachments/assets/8cb4b442-fccd-422f-b858-0c61b5afcda9)
*new match diagram*

Whenever the player accesses the match page, the page will request Phoenix.Presence to track that user and will let the GenServer know.  
The page will also subscribe to the match PubSub, which will be used by the GenServer to broadcast updates by sending the match state everytime it changes (a new player joined/left, game has started, a hint was given ...)
Liveview is smart enough to only send into the websocket what have change, making it easier and fast, moreover, the page re-renders to reflect the match changes, adding or removing buttons and/or information.
Whenever a player do something in the game, the page will use the client module as an interface for sending messages to the server.  

## Running the code:

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

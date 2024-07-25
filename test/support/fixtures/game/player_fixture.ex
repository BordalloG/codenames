defmodule Codenames.GameFixtures do
  def player_fixture(attrs \\ %{}) do
    Enum.into(attrs, %{
      id: UUID.uuid4(),
      nick: "Player #{System.unique_integer()}",
      role: :operative
    })
  end
end

defmodule Echo.TestGuardianSerializer do
  @behaviour Guardian.Serializer

  alias Echo.User

  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id) do
    {:ok, %User{id: id}}
  end

  def from_token(_), do: { :error, "Unknown resource type" }
end

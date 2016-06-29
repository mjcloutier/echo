defmodule Echo.Guardian.OAuthUserSerializer do
  @behaviour Guardian.Serializer

  alias Echo.Repo
  alias Echo.User
  alias Echo.Application

  def for_token(user = %User{}) do
    {:ok, "User:#{user.id}"}
  end
  def for_token(application = %Application{}) do
    {:ok, "Application:#{application.id}"}
  end
  def for_token(_), do: {:error, "Unknown resource"}

  def from_token("User:" <> id) do
    {:ok, Repo.get!(User, id)}
  end
  def from_token("Application:" <> id) do
    {:ok, Repo.get!(Application, id)}
  end
  def from_token(_), do: { :error, "Unknown resource" }
end

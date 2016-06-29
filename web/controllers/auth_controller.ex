defmodule Echo.AuthController do
  use Echo.Web, :controller

  alias Echo.Google
  alias Echo.User
  alias Echo.Repo

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "You have been logged out!")
    |> redirect(to: session_path(conn, :new))
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    token = get_token!(provider, code)

    # Request the user's data with the access token
    user = get_user!(provider, token)

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    case valid_domain?(user[:hd]) do
      true ->
        conn
        |> establish_user_session(user, token)
        |> redirect(to: "/")
      false ->
        conn
        |> put_flash(:error, "Your user is not allowed to access Echo")
        |> redirect(to: session_path(conn, :new))
    end
  end

  defp establish_user_session(conn, user, token) do
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, token.access_token)
    |> sign_in_echo_user
  end

  defp sign_in_echo_user(conn) do
    user = get_session(conn, :current_user)

    {_, echo_user} =
      case Repo.get_by(User, email: user.email) do
        nil -> Repo.insert(%User{email: user.email})
        existing_user -> {:ok, existing_user}
      end

    conn
    |> assign(:current_user_id, echo_user)
    |> Guardian.Plug.sign_in(echo_user)
  end

  defp authorize_url!("google"), do: Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email")
  defp authorize_url!(_), do: raise("No matching provider")

  defp get_token!("google", code), do: Google.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider"

  defp get_user!("google", token) do
    {:ok, %{body: user}} = OAuth2.AccessToken.get(token, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")

    %{email: user["email"], avatar: user["picture"], hd: user["hd"]}
  end

  defp allowed_domains do
    Application.get_env(:echo, Echo)[:valid_oauth_domains]
  end

  defp valid_domain?(domain) do
    Enum.member?(allowed_domains, domain)
  end
end

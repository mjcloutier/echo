defmodule Echo.Authentication.Plug.Api.ErrorHandler do
  @moduledoc """
  Guardian-compatible error handler for failed authentication and authorization
  over the API.
  """

  import Plug.Conn

  def unauthenticated(conn, _params) do
    msg = %{errors: ["Unauthenticated"]} |> Poison.encode!

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, msg)
  end

  def unauthorized(conn, _params) do
    msg = %{errors: ["Unauthorized"]} |> Poison.encode!

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, msg)
  end

  def already_authenticated(conn, _params) do
    conn |> halt
  end
end

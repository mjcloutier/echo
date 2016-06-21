defmodule Echo.Authentication.Plug.ErrorHandler do
  @moduledoc """
  Guardian-compatible error handler for failed authentication and authorization.
  """

  use Phoenix.Controller

  import Plug.Conn
  import Echo.Router.Helpers

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You must sign in to view that page")
    |> redirect(to: session_path(conn, :new))
  end

  def unauthorized(conn, _params) do
    conn
    |> respond(response_type(conn), 403, "Unauthorized")
  end

  def already_authenticated(conn, _params) do
    conn |> halt
  end

  defp respond(conn, :html, status, msg) do
    try do
      conn
      |> configure_session(drop: true)
      |> put_resp_content_type("text/plain")
      |> send_resp(status, msg)
    rescue ArgumentError ->
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(status, msg)
    end
  end
  defp respond(conn, :json, status, msg) do
    json_msg = %{errors: [msg]} |> Poison.encode!

    try do
      conn
      |> configure_session(drop: true)
      |> put_resp_content_type("application/json")
      |> send_resp(status, json_msg)
    rescue ArgumentError ->
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(status, json_msg)
    end
  end

  defp response_type(conn) do
    accept = accept_header(conn)

    if Regex.match?(~r/json/, accept) do
      :json
    else
      :html
    end
  end

  defp accept_header(conn) do
    value = conn |> get_req_header("accept") |> List.first

    value || ""
  end
end

defmodule Echo.SessionController do
  use Echo.Web, :controller

  plug :put_layout, "signed_out.html"

  def new(conn, _params) do
    conn |> render
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Goodbye")
    |> redirect(to: session_path(conn, :new))
  end
end

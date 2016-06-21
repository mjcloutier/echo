defmodule Echo.SessionController do
  use Echo.Web, :controller

  # plug Guardian.Plug.EnsureAuthenticated, Echo.Authentication.Plug.ErrorHandler
  plug :put_layout, "signed_out.html"

  def new(conn, _params) do
    conn |> render
  end
end

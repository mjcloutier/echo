defmodule Echo.ControllerHelpers do
  import Plug.Conn
  import Phoenix.Controller


  # TODO: Put me somewhere else
  def render_error(conn, error_msg) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: error_msg})
    |> halt # Stop execution of further plugs, return response now
  end
end

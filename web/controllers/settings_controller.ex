defmodule Echo.SettingsController do
  use Echo.Web, :controller

  def index(conn, _params) do
    render conn, :index,
      current_user: conn.assigns.current_user

  end
end

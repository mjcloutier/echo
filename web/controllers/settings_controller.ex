defmodule Echo.SettingsController do
  use Echo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

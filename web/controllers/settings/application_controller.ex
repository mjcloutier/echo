defmodule Echo.Settings.ApplicationController do
  use Echo.Web, :controller

  def index(conn, _params) do
    applications = [
      %{name: "Something"},
      %{name: "Something else"}
    ]
    render conn, "index.html", applications: applications
  end
end

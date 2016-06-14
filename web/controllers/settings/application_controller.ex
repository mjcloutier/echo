defmodule Echo.Settings.ApplicationController do
  use Echo.Web, :controller

  alias Echo.Application

  def index(conn, _params) do
    applications = Repo.all(from a in Application,
                            order_by: [desc: a.inserted_at])

    render conn, "index.html", applications: applications
  end
end

defmodule Echo.Settings.ApplicationController do
  use Echo.Web, :controller

  alias Echo.Application

  def index(conn, _params) do
    applications = Repo.all(from a in Application,
                            order_by: [desc: a.inserted_at])

    render conn, "index.html", applications: applications
  end

  def new(conn, _params) do
    changeset = Application.changeset %Application{}

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"application" => application_params}) do
    changeset = Application.changeset(%Application{}, application_params)

    case Repo.insert(changeset) do
      {:ok, _application} ->
        conn
        |> put_flash(:info, "Application created.")
        |> redirect(to: application_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end

    render conn, "new.html"
  end
end

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

  def edit(conn, %{"id" => id}) do
    application = Repo.get!(Application, id)
    changeset = Application.changeset application

    render conn, "edit.html", changeset: changeset, application: application
  end

  def update(conn, %{"id" => id, "application" => application_params}) do
    application = Repo.get! Application, id
    changeset = Application.changeset application, application_params

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Application updated successfully")
        |> redirect(to: application_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, application: application
    end
  end
end

defmodule Echo.Router do
  use Echo.Web, :router

  alias Echo.Repo
  alias Echo.Application

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authentication_required do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: Echo.Authentication.Plug.ErrorHandler
    plug :assign_current_user
  end

  pipeline :api_authentication do
    plug :verify_application
    plug :sign_in_application
    plug Guardian.Plug.EnsureAuthenticated, handler: Echo.Authentication.Plug.Api.ErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", Echo.Api.V1, as: :api_v1 do
    pipe_through [:api, :api_authentication]

    resources "/notifications", NotificationController, only: [:index, :update]
  end

  scope "/auth", Echo do
    pipe_through :browser

    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/", Echo do
    pipe_through [:browser, :authentication_required]

    delete "/session", SessionController, :delete

    get "/", NotificationController, :index
    resources "/notifications", NotificationController

    get "/settings", SettingsController, :index
    resources "/settings/applications", Settings.ApplicationController, only: [:index, :new, :create, :edit, :update]
  end

  scope "/", Echo do
    pipe_through :browser

    resources "/sessions", SessionController, only: [:new]
  end

  defp assign_current_user(conn, _params) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
  end

  defp verify_application(conn, _params) do
    app_key = conn.params["app_id"] || conn |> get_req_header("app_id") |> Enum.at(0)
    app_secret = conn.params["app_secret"] || conn |> get_req_header("app_secret") |> Enum.at(0)

    conn |> handle_key_secret(app_key, app_secret)
  end

  defp handle_key_secret(conn, nil, nil) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "You must provide an Application ID and secret"})
    |> halt
  end
  defp handle_key_secret(conn, key, secret) do
    application = Repo.get_by(Application, app_key: key, app_secret: secret)
    conn |> assign(:application_id, application.id)
  end

  defp sign_in_application(conn, _params) do
    application = Repo.get(Application, conn.assigns.application_id)

    conn
    |> Guardian.Plug.api_sign_in(application)
  end
end

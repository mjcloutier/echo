defmodule Echo.Router do
  use Echo.Web, :router

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

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", Echo.Api.V1, as: :api_v1 do
    pipe_through :api

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
    resources "/notifications", NotificationController, except: [:show]

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
end

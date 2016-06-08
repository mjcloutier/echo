defmodule Echo.Router do
  use Echo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Echo do
    pipe_through :api

    resources "/v1/notifications", Api.V1.NotificationController, only: [:index, :show]
  end

  scope "/", Echo do
    pipe_through :browser # Use the default browser stack

    get "/", NotificationController, :index

    resources "/notifications", NotificationController
  end
end

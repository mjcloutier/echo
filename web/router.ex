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

  scope "/api/v1", Echo.Api.V1, as: :api_v1 do
    pipe_through :api

    resources "/notifications", NotificationController, only: [:index, :update]
  end

  scope "/", Echo do
    pipe_through :browser

    get "/", NotificationController, :index
    resources "/notifications", NotificationController, except: [:show]

    get "/settings", SettingsController, :index
    resources "/settings/applications", Settings.ApplicationController, only: [:index]
  end
end

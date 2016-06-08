#require IEx
defmodule Echo.Api.V1.NotificationController do
  use Echo.Web, :controller
  require Logger

  alias Echo.Notification
  alias Echo.Customer

  def index(conn, %{"user_id" => user_id}) do
    Logger.debug "Loggin some text for user_id: #{user_id}."

    customer = case Repo.get_by(Customer, app_user_id: user_id) do
      nil -> Repo.insert!(Customer.changeset(%Customer{}, %{ app_user_id: user_id }))
      customer -> customer
    end

    notifications = Repo.all(Notification)
    render(conn, "index.json", notifications: notifications)
  end
  def index(conn, _params) do
    Logger.debug "Logging some userless text, this shit gonna get deprecated so hard."
    notifications = Repo.all(Notification)
    render(conn, "index.json", notifications: notifications)
  end

  def show(conn, %{"id" => id}) do
    notification = Repo.get!(Notification, id)
    render(conn, "show.json", notification: notification)
  end
end

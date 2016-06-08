require IEx
defmodule Echo.Api.V1.NotificationController do
  use Echo.Web, :controller
  require Logger

  alias Echo.Notification
  alias Echo.Customer

  plug :find_customer when action in [:index]

  def index(conn, %{"user_id" => user_id}) do
    Logger.debug "Loggin some text for user_id: #{user_id}."

    notifications = Repo.all(Notification)
    render(conn, "index.json", notifications: notifications)
  end

  def show(conn, %{"id" => id}) do
    notification = Repo.get!(Notification, id)
    render(conn, "show.json", notification: notification)
  end

  def find_customer(conn, _) do
    customer = case Repo.get_by(Customer, app_user_id: conn.params["user_id"]) do
      nil -> Repo.insert!(Customer.changeset(%Customer{}, %{ app_user_id: conn.params["user_id"] }))
      customer -> customer
    end
    assign(conn, :customer, customer)
  end
end

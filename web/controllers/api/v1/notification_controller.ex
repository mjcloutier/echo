defmodule Echo.Api.V1.NotificationController do
  use Echo.Web, :controller

  alias Echo.Notification

  def index(conn, _params) do
    notifications = Repo.all(Notification)
    render(conn, "index.json", notifications: notifications)
  end

  def show(conn, %{"id" => id}) do
    notification = Repo.get!(Notification, id)
    render(conn, "show.json", notification: notification)
  end
end

defmodule Echo.Api.V1.NotificationView do
  use Echo.Web, :view

  def render("index.json", %{notifications: notifications}) do
    %{data: render_many(notifications, Echo.Api.V1.NotificationView, "notification.json")}
  end

  def render("show.json", %{notification: notification}) do
    %{data: render_one(notification, Echo.Api.V1.NotificationView, "notification.json")}
  end

  def render("notification.json", %{notification: notification}) do
    %{id: notification.id,
      body: notification.body}
  end
end

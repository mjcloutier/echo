defmodule Echo.Api.V1.NotificationView do
  use Echo.Web, :view

  def render("index.json", %{notifications: notifications}) do
    %{notifications: render_many(notifications, Echo.Api.V1.NotificationView, "notification.json")}
  end

  def render("acknowledged.json", _params) do
    %{ great: "success" }
  end

  def render("failed_ack.json", %{sent_notification: sent_notification}) do
    %{ error: "Acknowledge failed for notification ##{sent_notification.notification_id}" }
  end

  def render("404.json", _params) do
    %{ error: "Could not find resource" }
  end

  def render("notification.json", %{notification: notification}) do
    %{ id:    notification.id,
       body:  notification.body,
       title: notification.title,
       summary: notification.summary
      }
  end
end

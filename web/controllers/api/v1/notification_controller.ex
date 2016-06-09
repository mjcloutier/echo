defmodule Echo.Api.V1.NotificationController do
  use Echo.Web, :controller
  import Echo.ControllerHelpers, only: [render_error: 2]

  alias Echo.Customer
  alias Echo.Notification
  alias Echo.SentNotification

  plug :find_customer_or_halt
  plug :find_unread_relevant_notifications
  plug :mark_new_notifications_as_sent

  def index(conn, _params) do
    render(conn, "index.json", notifications: conn.assigns.unread_notifications)
  end


  defp find_customer_or_halt(conn, _opts) do
    case conn.params["user_id"] do
      nil     -> conn |> render_error("Must provide a user_id.")
      user_id -> conn |> assign(:customer, Customer.find_or_create(user_id))
    end
  end

  defp find_unread_relevant_notifications(conn, _opts) do
    assign(conn, :unread_notifications, Notification.unread_for(conn.assigns.customer))
  end

  defp mark_new_notifications_as_sent(conn, _opts) do
    Enum.each(conn.assigns.unread_notifications, fn notification ->
      SentNotification.create(conn.assigns.customer, notification)
    end)
    conn
  end
end

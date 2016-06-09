require IEx
defmodule Echo.Api.V1.NotificationController do
  use Echo.Web, :controller
  require Logger

  alias Echo.Customer
  alias Echo.Notification
  alias Echo.SentNotification

  plug :find_customer_or_halt
  plug :find_unread_notifications
  plug :mark_new_notifications_as_sent

  def index(conn, _params) do
    render(conn, "index.json", notifications: conn.assigns[:unread_notifications])
  end


  defp find_customer_or_halt(conn, _opts) do
    case conn.params["user_id"] do
      nil     -> conn |> render_error
      user_id -> conn |> fetch_or_build_customer(user_id)
    end
  end

  defp fetch_or_build_customer(conn, user_id) do
    customer = case Repo.get_by(Customer, app_user_id: user_id) do
      nil -> Repo.insert!(Customer.changeset(%Customer{}, %{ app_user_id: user_id }))
      customer -> customer
    end
    assign(conn, :customer, customer)
  end

  defp render_error(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Must provide a user_id."})
    |> halt # Stop execution of further plugs, return response now
  end

  defp find_unread_notifications(conn, _opts) do
    sent_notification_ids = Repo.all(from sent in SentNotification,
                                      where: sent.customer_id == ^conn.assigns[:customer].id,
                                      select: sent.notification_id)
    unread_notifications =  Repo.all(from n in Notification,
                                      where: not n.id in ^sent_notification_ids)

    assign(conn, :unread_notifications, unread_notifications)
  end

  defp mark_new_notifications_as_sent(conn, _opts) do
    Enum.each(conn.assigns[:unread_notifications], fn notification ->
      Repo.insert!(SentNotification.changeset(%SentNotification{}, %{ customer_id: conn.assigns[:customer].id,
                                                                      notification_id: notification.id }))
    end)
    conn
  end
end

defmodule Echo.Api.V1.NotificationController do
  use Echo.Web, :controller

  alias Echo.Customer
  alias Echo.Notification
  alias Echo.SentNotification

  plug :find_customer_or_halt when action in [:index]
  plug :find_unread_relevant_notifications when action in [:index]
  plug :mark_new_notifications_as_sent when action in [:index]

  def index(conn, _params) do
    render(conn, "index.json", notifications: conn.assigns.unread_notifications)
  end

  def update(conn, %{"id" => id, "user_id" => user_id}) do
    sent_notification = case SentNotification.find_by(user_id, id) do
      {:error, :not_found} -> render_error(conn, "Can not find a notification for that user.")
      notification         -> notification
    end
    changeset = SentNotification.changeset(sent_notification, %{acknowledged: true})

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> render("acknowledged.json")
      {:error, _} ->
        render(conn, "failed_ack.json", sent_notification: sent_notification)
    end
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

defmodule Echo.Api.V1.NotificationController do
  use Echo.Web, :controller

  import Echo.ControllerHelpers, only: [render_error: 2]

  alias Echo.Customer
  alias Echo.Notification
  alias Echo.SentNotification

  plug :halt_if_no_user_id
  plug :find_or_create_customer when action in [:index]
  plug :find_unread_relevant_notifications when action in [:index]
  plug :mark_new_notifications_as_sent when action in [:index]
  plug :find_customer_or_halt when action in [:update]

  def index(conn, _params) do
    render(conn, "index.json", notifications: conn.assigns.unread_notifications)
  end

  def update(conn, %{"id" => notification_id}) do
    #notification = Repo.get(Notification, notification_id)

    sent = Repo.get_by(SentNotification, customer_id: conn.assigns.customer.id, notification_id: notification_id)
    unless sent do
      conn
      |> put_status(:not_found)
      |> render "404.json"
    else
      changeset = SentNotification.changeset(sent, %{acknowledged: true})
      case Repo.update(changeset) do
        {:ok, _} ->
          conn
          |> render("acknowledged.json")
        {:error, _} ->
          render(conn, "failed_ack.json", sent_notification: sent)
      end
    end
  end


  defp halt_if_no_user_id(conn, _opts) do
    case conn.params["user_id"] do
      nil -> conn |> render_error("Must provide a user_id.")
      _   -> conn
    end
  end

  defp find_customer_or_halt(conn, _opts) do
    case Repo.get_by(Customer, app_user_id: conn.params["user_id"]) do
      nil -> conn |> render_error("Customer not found.")
      c   -> conn |> assign(:customer, c)
    end
  end

  defp find_or_create_customer(conn, _opts) do
    assign(conn, :customer, Customer.find_or_create(conn.params["user_id"]))
  end

  defp find_unread_relevant_notifications(conn, _opts) do
    assign(conn, :unread_notifications, Notification.unread_for(conn.assigns.customer))
  end

  defp mark_new_notifications_as_sent(conn, _opts) do
    Enum.each(conn.assigns.unread_notifications, fn notification ->
      case Repo.get_by(SentNotification, customer_id: conn.assigns.customer.id, notification_id: notification.id) do
        nil -> SentNotification.create(conn.assigns.customer, notification)
        _ -> nil
      end
    end)
    conn
  end
end

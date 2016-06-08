require IEx
defmodule Echo.Api.V1.NotificationController do
  use Echo.Web, :controller
  require Logger

  alias Echo.Customer
  alias Echo.Notification
  alias Echo.SentNotification

  plug :find_customer_or_halt
  plug :filter_sent_notifications

  def index(conn, _params) do

    # Debug stuffs
    user_count = List.first(Repo.all(from c in Customer, select: count(c.id)))
    Logger.debug "Current number of users: #{user_count}"


    unread_notifications = conn.assigns[:unread_notifications]

    # Mark em as sent.
    Enum.each(unread_notifications, fn notification ->
      # This could potentially dupe if we don't filter unread properly
      Repo.insert!(SentNotification.changeset(%SentNotification{}, %{ customer_id: conn.assigns[:customer].id, notification_id: notification.id }))
    end)

    render(conn, "index.json", notifications: unread_notifications)
  end

  defp find_customer_or_halt(conn, _opts) do
    case conn.params["user_id"] do
      nil     -> conn |> render_error
      user_id -> conn |> fetch_or_build_customer(user_id)
    end
  end

  defp filter_sent_notifications(conn, _opts) do
    # TODO: actually filter this out.
    assign(conn, :unread_notifications, Repo.all(Notification))
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
end

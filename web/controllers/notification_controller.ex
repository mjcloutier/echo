defmodule Echo.NotificationController do
  use Echo.Web, :controller

  alias Echo.Notification

  plug :scrub_params, "notification" when action in [:create, :update]

  def index(conn, _params) do
    notifications = Repo.all(from n in Notification,
                             order_by: [desc: n.inserted_at])
    render(conn, "index.html", notifications: notifications)
  end

  def new(conn, _params) do
    changeset = Notification.changeset(%Notification{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"notification" => notification_params}) do
    change_params = scrub_type_params(notification_params)
    changeset = Notification.changeset(%Notification{}, notification_params)

    case Repo.insert(changeset) do
      {:ok, _notification} ->
        conn
        |> put_flash(:info, "Notification created successfully.")
        |> redirect(to: notification_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    notification = Repo.get!(Notification, id)
    changeset = Notification.changeset(notification)

    echo_type =
      cond do
        notification.start_at ->
          "scheduled"
        notification.session_count ->
          "login-count"
        !notification.start_at && !notification.session_count ->
          "immediate"
      end

    render(conn, "edit.html", notification: notification, changeset: changeset, echo_type: echo_type)
  end

  def update(conn, %{"id" => id, "notification" => notification_params}) do
    notification = Repo.get!(Notification, id)

    change_params = scrub_type_params(notification_params)
    changeset = Notification.changeset(notification, change_params)

    echo_type =
      cond do
        notification.start_at ->
          "scheduled"
        notification.session_count ->
          "login-count"
        !notification.start_at && !notification.session_count ->
          "immediate"
      end

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Notification updated successfully.")
        |> redirect(to: notification_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", notification: notification, changeset: changeset, echo_type: echo_type)
    end
  end

  def delete(conn, %{"id" => id}) do
    notification = Repo.get!(Notification, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(notification)

    conn
    |> put_flash(:info, "Notification deleted successfully.")
    |> redirect(to: notification_path(conn, :index))
  end

  def scrub_type_params(params) do
    change_params =
      case params["type"] do
        "immediate"   -> %{ params | "start_at" => nil, "session_count" => nil }
        "scheduled"   -> %{ params | "session_count" => nil }
        "login-count" -> %{ params | "start_at" => nil, "end_at" => nil, "immediate_end_at" => nil }
      end

    change_params =
      if params["immediate_end_at"] do
        %{ change_params | "end_at" => change_params["immediate_end_at"] }
      else
        change_params
      end
    change_params
  end
end

defmodule Echo.NotificationController do
  use Echo.Web, :controller

  alias Echo.Notification
  alias Echo.SentNotification
  alias Echo.Application
  import Ecto.Query
  alias Echo.NotificationStatistics

  plug :scrub_params, "notification" when action in [:create, :update]

  def index(conn, params) do
    page =
      Notification
      |> order_by(desc: :inserted_at)
      |> preload(:application)
      |> Repo.paginate(params)

    render conn, :index,
      page: page,
      notifications: page.entries
  end

  def show(conn, %{"id" => id}) do
    notification =
      Notification
      |> Repo.get!(id)
      |> Repo.preload([:application, :created_by])

    info =
      NotificationStatistics.stats_for(notification)

    render(conn, :show, info: info, notification: notification)
  end

  def new(conn, _params) do
    changeset = Notification.changeset(%Notification{}, %{})

    render(conn, :new,
     changeset: changeset,
     available_applications: Repo.all(Application.available))
  end

  def create(conn, %{"notification" => notification_params}) do
    change_params = Map.put(scrub_type_params(notification_params),
                            "created_by_id", conn.assigns.current_user.id)
    changeset = Notification.changeset(%Notification{}, change_params)

    case Repo.insert(changeset) do
      {:ok, _notification} ->
        conn
        |> put_flash(:info, "Notification created successfully.")
        |> redirect(to: notification_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset,
                                 available_applications: Repo.all(Application.available))
    end
  end

  def edit(conn, %{"id" => id}) do
    notification =
      Repo.get!(Notification, id)
      |> Repo.preload([:application])
    changeset = Notification.changeset(notification, %{})

    echo_type =
      cond do
        notification.start_at ->
          "scheduled"
        notification.session_count ->
          "login-count"
        !notification.start_at && !notification.session_count ->
          "immediate"
      end

    render(conn, "edit.html", notification: notification,
                              changeset: changeset,
                              echo_type: echo_type,
                              available_applications: Repo.all(Application.available))
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
        render(conn, "edit.html", notification: notification,
                                  changeset: changeset,
                                  echo_type: echo_type,
                                  available_applications: Repo.all(Application.available))
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
        "immediate"   -> %{params | "start_at" => nil, "session_count" => nil}
        "scheduled"   -> %{params | "session_count" => nil}
        "login-count" -> %{params | "start_at" => nil, "end_at" => nil, "immediate_end_at" => nil}
      end

    if params["immediate_end_at"] do
      %{change_params | "end_at" => change_params["immediate_end_at"]}
    else
      change_params
    end
  end
end

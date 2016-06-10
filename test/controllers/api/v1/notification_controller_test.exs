require IEx

defmodule Echo.Api.V1.NotificationControllerTest do
  use Echo.ConnCase

  alias Echo.Customer
  alias Echo.Notification
  alias Echo.SentNotification

  @valid_attrs %{body: "some content", title: "Cool peas."}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "index requires a user_id", %{conn: conn} do
    conn = get conn, api_v1_notification_path(conn, :index)
    assert json_response(conn, 403)["error"] =~ "Must provide a user_id."
  end

  test "index creates a new user when given the user_id", %{conn: conn} do
    assert Echo.Repo.all(from c in Customer, select: count(c.id)) == [0]

    conn = get conn, api_v1_notification_path(conn, :index, user_id: "big_ass_uuid")
    assert json_response(conn, 200)["notifications"] == []

    assert Echo.Repo.all(from c in Customer, select: count(c.id)) == [1]
  end

  test "index marks a notification as sent", %{conn: conn} do
    Echo.Repo.insert!(%Notification{})
    assert Echo.Repo.all(from c in SentNotification, select: count(c.id)) == [0]

    conn = get conn, api_v1_notification_path(conn, :index, user_id: "big_ass_uuid")
    assert json_response(conn, 200)["notifications"] |> Enum.count == 1

    assert Echo.Repo.all(from c in SentNotification, select: count(c.id)) == [1]
  end

  test "doesn't create new sent_notifications for a customer if it's already been sent", %{conn: conn} do
    n = Echo.Repo.insert!(%Notification{})
    c = Echo.Repo.insert!(%Customer{app_user_id: "big_ass_uuid"})
    Echo.Repo.insert!(%SentNotification{customer_id: c.id, notification_id: n.id})

    conn = get conn, api_v1_notification_path(conn, :index, user_id: c.app_user_id)
    assert json_response(conn, 200)["notifications"] |> Enum.count == 1
    assert Echo.Repo.all(from c in SentNotification, select: count(c.id)) == [1]
  end

  test "doesn't return a notification if it's been sent and acknowledged", %{conn: conn} do
    n = Echo.Repo.insert!(%Notification{})
    c = Echo.Repo.insert!(%Customer{app_user_id: "big_ass_uuid"})
    Echo.Repo.insert!(%SentNotification{customer_id: c.id, notification_id: n.id, acknowledged: true})

    conn = get conn, api_v1_notification_path(conn, :index, user_id: c.app_user_id)
    assert json_response(conn, 200)["notifications"] |> Enum.count == 0
    assert Echo.Repo.all(from c in Customer, select: count(c.id)) == [1]
  end

  test "does return a notification if it's been sent and not acknowledged", %{conn: conn} do
    n = Echo.Repo.insert!(%Notification{})
    c = Echo.Repo.insert!(%Customer{app_user_id: "big_ass_uuid"})
    Echo.Repo.insert!(%SentNotification{customer_id: c.id, notification_id: n.id})

    conn = get conn, api_v1_notification_path(conn, :index, user_id: c.app_user_id)
    assert json_response(conn, 200)["notifications"] |> Enum.count == 1
    assert Echo.Repo.all(from c in Customer, select: count(c.id)) == [1]
  end

  test "doesn't return expired notifications", %{conn: conn} do
    Echo.Repo.insert!(%Notification{end_at: gimme_the_past})

    conn = get conn, api_v1_notification_path(conn, :index, user_id: "ajsdklf")
    assert json_response(conn, 200)["notifications"] |> Enum.count == 0
    assert Echo.Repo.all(from s in SentNotification, select: count(s.id)) == [0]
  end

  test "doesn't return notifications that are scheduled for the future", %{conn: conn} do
    Echo.Repo.insert!(%Notification{start_at: gimme_the_future})

    conn = get conn, api_v1_notification_path(conn, :index, user_id: "ajsdklf")
    assert json_response(conn, 200)["notifications"] |> Enum.count == 0
    assert Echo.Repo.all(from s in SentNotification, select: count(s.id)) == [0]
  end

  test "returns notifications inside of a start-end date", %{conn: conn} do
    Echo.Repo.insert!(%Notification{start_at: gimme_the_past, end_at: gimme_the_future})

    conn = get conn, api_v1_notification_path(conn, :index, user_id: "ajsdklf")
    assert json_response(conn, 200)["notifications"] |> Enum.count == 1
    assert Echo.Repo.all(from s in SentNotification, select: count(s.id)) == [1]
  end

  test "acknowledges a notification", %{conn: conn} do
    notification = Echo.Repo.insert!(%Notification{})
    c = Echo.Repo.insert!(%Customer{app_user_id: "big_ass_uuid"})
    s = Echo.Repo.insert!(%SentNotification{customer_id: c.id, notification_id: notification.id})

    conn = put conn, api_v1_notification_path(conn, :update, notification, user_id: "big_ass_uuid")
    assert json_response(conn, 200)["great"] == "success"
    assert Repo.get!(SentNotification, s.id).acknowledged
  end

  test "doesn't bomb if fails to find customer", %{conn: conn} do
    notification = Echo.Repo.insert!(%Notification{})

    conn = put conn, api_v1_notification_path(conn, :update, notification, user_id: "big_ass_uuid")
    assert json_response(conn, 403)
  end

  test "doesn't bomb if fails to find notification", %{conn: conn} do
    Echo.Repo.insert!(%Customer{app_user_id: "big_ass_uuid"})

    conn = put conn, api_v1_notification_path(conn, :update, 32, user_id: "big_ass_uuid")
    assert json_response(conn, 404)
  end

  test "fetches session notifications if given a sign_in_count", %{conn: conn} do
    Echo.Repo.insert!(%Notification{session_count: 1})
    Echo.Repo.insert!(%Notification{session_count: 3})
    Echo.Repo.insert!(%Notification{})

    conn = get conn, api_v1_notification_path(conn, :index, user_id: "big_ass_uuid", sign_in_count: 1)
    assert json_response(conn, 200)["notifications"] |> Enum.count == 2
  end

  test "ignores session notifications if no sign in is passed", %{conn: conn} do
    Echo.Repo.insert!(%Notification{session_count: 1})
    Echo.Repo.insert!(%Notification{session_count: 3})
    Echo.Repo.insert!(%Notification{})

    conn = get conn, api_v1_notification_path(conn, :index, user_id: "big_ass_uuid")
    assert json_response(conn, 200)["notifications"] |> Enum.count == 1
  end

  # 1.3 has Calendar data types, but there's still some hurdles to jump through
  # to interop with Ecto.DateTimes, couldn't just Calendar.DateTime.now |> ...add(30) |> Ecto.DateTime.parse
  # So I gave up and I'm doing it the erlang way
  def gimme_the_past do
    {{y, month, d}, {_, _, _}} = :os.timestamp |> :calendar.now_to_datetime
    {y, month-1, d} |> Ecto.Date.from_erl
  end

  def gimme_the_future do
    {{y, month, d}, {_, _, _}} = :os.timestamp |> :calendar.now_to_datetime
    {y, month+1, d} |> Ecto.Date.from_erl
  end
end

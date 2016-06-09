require IEx

defmodule Echo.Api.V1.NotificationControllerTest do
  use Echo.ConnCase

  alias Echo.Customer
  alias Echo.Notification
  alias Echo.SentNotification

  @valid_attrs %{body: "some content"}
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

  test "doesn't return a notification if it's been sent", %{conn: conn} do
    n = Echo.Repo.insert!(%Notification{})
    c = Echo.Repo.insert!(%Customer{app_user_id: "big_ass_uuid"})
    Echo.Repo.insert!(%SentNotification{customer_id: c.id, notification_id: n.id})

    conn = get conn, api_v1_notification_path(conn, :index, user_id: c.app_user_id)
    assert json_response(conn, 200)["notifications"] |> Enum.count == 0
    assert Echo.Repo.all(from c in Customer, select: count(c.id)) == [1]
  end
end

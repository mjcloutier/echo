require IEx
defmodule Echo.Api.V1.NotificationControllerTest do
  use Echo.ConnCase

  alias Echo.Notification
  alias Echo.Customer

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

end

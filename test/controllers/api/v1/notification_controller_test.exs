defmodule Echo.Api.V1.NotificationControllerTest do
  use Echo.ConnCase

  alias Echo.Notification
  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do


    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_notification_path(conn, :index)
    assert json_response(conn, 200)["notifications"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    notification = Repo.insert! %Notification{}
    conn = get conn, api_v1_notification_path(conn, :show, notification)
    assert json_response(conn, 200)["notification"] == %{"id" => notification.id,
      "body" => notification.body}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_notification_path(conn, :show, -1)
    end
  end
end

defmodule Echo.NotificationControllerTest do
  use Echo.ConnCase

  alias Echo.Notification
  @valid_attrs %{
    title: "Cool peas",
    body: "some content"
  }
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, notification_path(conn, :index)

    assert html_response(conn, 200) =~ "Dashboard"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, notification_path(conn, :new)

    assert html_response(conn, 200) =~ "New echo"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    notification = Repo.insert! %Notification{}

    conn = get conn, notification_path(conn, :edit, notification)

    assert html_response(conn, 200) =~ "Edit echo"
  end

  test "deletes chosen resource", %{conn: conn} do
    notification = Repo.insert! %Notification{}

    conn = delete conn, notification_path(conn, :delete, notification)

    assert redirected_to(conn) == notification_path(conn, :index)
    refute Repo.get(Notification, notification.id)
  end
end

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

  test "creates resource and redirects when data is valid", %{conn: conn} do
    request_params = Map.merge(%{type: "immediate", session_count: 0, start_at: nil}, @valid_attrs)

    conn = post conn, notification_path(conn, :create), notification: request_params

    assert redirected_to(conn) == notification_path(conn, :index)
    assert Repo.get_by(Notification, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    request_params = Map.merge(%{type: "immediate", session_count: 0, start_at: nil}, @invalid_attrs)

    conn = post conn, notification_path(conn, :create), notification: request_params

    assert html_response(conn, 200) =~ "New echo"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    notification = Repo.insert! %Notification{}

    conn = get conn, notification_path(conn, :edit, notification)

    assert html_response(conn, 200) =~ "Edit echo"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    request_params = Map.merge(%{type: "immediate", session_count: 0, start_at: nil}, @valid_attrs)
    notification = Repo.insert! %Notification{}

    conn = put conn, notification_path(conn, :update, notification), notification: request_params

    assert redirected_to(conn) == notification_path(conn, :index)
    assert Repo.get_by(Notification, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    request_params = Map.merge(%{type: "immediate", session_count: 0, start_at: nil}, @invalid_attrs)
    notification = Repo.insert! %Notification{}

    conn = put conn, notification_path(conn, :update, notification), notification: request_params

    assert html_response(conn, 200) =~ "Edit echo"
  end

  test "deletes chosen resource", %{conn: conn} do
    notification = Repo.insert! %Notification{}

    conn = delete conn, notification_path(conn, :delete, notification)

    assert redirected_to(conn) == notification_path(conn, :index)
    refute Repo.get(Notification, notification.id)
  end
end

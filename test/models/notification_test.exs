defmodule Echo.NotificationTest do
  use Echo.ModelCase

  alias Echo.Notification

  @valid_attrs %{
    title: "Cool peas",
    body: "some content"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Notification.changeset(%Notification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Notification.changeset(%Notification{}, @invalid_attrs)
    refute changeset.valid?
  end
end

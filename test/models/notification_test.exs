defmodule Echo.NotificationTest do
  use Echo.ModelCase

  alias Echo.Notification

  @valid_attrs %{
    title: "Cool peas",
    body: "some content",
    application_id: 1337
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    u = Repo.insert!(%Echo.User{ email: "email@email.com" })
    c = Map.put(@valid_attrs, :created_by_id, u.id)
    changeset = Notification.changeset(%Notification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Notification.changeset(%Notification{}, @invalid_attrs)
    refute changeset.valid?
  end
end

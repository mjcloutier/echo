defmodule Echo.SentNotificationTest do
  use Echo.ModelCase

  alias Echo.SentNotification

  @valid_attrs %{acknowledged: true, customer_id: 42, notification_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SentNotification.changeset(%SentNotification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SentNotification.changeset(%SentNotification{}, @invalid_attrs)
    refute changeset.valid?
  end
end

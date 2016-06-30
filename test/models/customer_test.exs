defmodule Echo.CustomerTest do
  use Echo.ModelCase

  alias Echo.Customer

  @valid_attrs %{app_user_id: "some content", application_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Customer.changeset(%Customer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Customer.changeset(%Customer{}, @invalid_attrs)
    refute changeset.valid?
  end
end

defmodule Echo.ApplicationTest do
  use Echo.ModelCase

  alias Echo.Application

  @valid_attrs %{name: "some content", app_key: "key", app_secret: "secret"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Application.changeset(%Application{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Application.changeset(%Application{}, @invalid_attrs)
    refute changeset.valid?
  end
end

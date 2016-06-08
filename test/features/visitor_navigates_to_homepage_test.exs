defmodule VisitorNavigatesToHomepageTest do
  use ExUnit.Case
  use Hound.Helpers

  alias Echo.Repo
  alias Echo.Notification

  hound_session

  test "Notifications are listed" do
    Repo.insert(%Notification{body: "Onomatopoeia"})
    Repo.insert(%Notification{body: "Cool peas"})

    navigate_to("/")

    assert visible_page_text() =~ "Listing notifications"
    assert visible_page_text() =~ "Cool peas"
    assert visible_page_text() =~ "Onomatopoeia"
  end
end

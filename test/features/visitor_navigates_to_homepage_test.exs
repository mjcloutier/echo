defmodule VisitorNavigatesToHomepageTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session

  test "Notifications are listed" do
    navigate_to("/")

    assert visible_page_text() =~ "Listing notifications"
  end
end

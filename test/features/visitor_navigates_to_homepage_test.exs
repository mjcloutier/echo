defmodule VisitorNavigatesToHomepageTest do
  use ExUnit.Case
  use Hound.Helpers

  alias Echo.Repo
  alias Echo.Notification

  hound_session

  test "Echos are listed" do
    Repo.insert(%Notification{title: "Onomatopoeia"})
    Repo.insert(%Notification{title: "Cool peas"})

    navigate_to("/")

    assert visible_page_text() =~ "Cool peas"
    assert visible_page_text() =~ "Onomatopoeia"
  end
end

defmodule Echo.NotificationView do
  use Echo.Web, :view

  def render("index.json", %{notifications: notifications}) do
    notifications
  end
end

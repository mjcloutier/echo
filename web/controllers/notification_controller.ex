defmodule Echo.NotificationController do
  use Echo.Web, :controller

  def index(conn, _params) do
    render conn, notifications: %{:body => "Hi there, I'm a notification"}
  end
end

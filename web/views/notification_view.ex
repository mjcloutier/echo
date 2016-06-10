defmodule Echo.NotificationView do
  use Echo.Web, :view

  def application_types do
    [{"FMS", "fms"}]
  end

  def echo_types do
    [
      {"Immediate", "immediate"},
      {"Scheduled", "scheduled"},
      {"Login count", "login-count"}
    ]
  end

  def default_echo_type do
    "immediate"
  end

  def echo_type(notification) do
    cond do
      notification.start_at ->
        "scheduled"
      notification.session_count ->
        "login-count"
      !notification.start_at && !notification.session_count ->
        "immediate"
    end
  end

  def flipped_echo_type(notification) do
    for { a, b } <- echo_types, do: {b, a}
  end

  def echo_type_display(type, notification) do
    cond do
      type == "login-count" ->
        "Login Count (#{notification.session_count})"
      type == "immediate" ->
        "Immediate"
      type == "scheduled" ->
        "Scheduled"
    end
  end
end

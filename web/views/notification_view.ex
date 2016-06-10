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
end

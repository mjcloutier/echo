defmodule Echo.NotificationView do
  use Echo.Web, :view
  import Scrivener.HTML

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

  def number_suffix(number) do
    reverse_list = Integer.digits(number) |> Enum.reverse

    if Enum.at(reverse_list, 1) == 1 do
      "th"
    else
      parse_suffix(Enum.at(reverse_list,0))
    end
  end

  def parse_suffix(num) do
    case num do
      1 -> "st"
      2 -> "nd"
      3 -> "rd"
      _ -> "th"
    end
  end

  def echo_type_display(type, notification) do
    cond do
      type == "login-count" ->
        "#{notification.session_count}#{number_suffix(notification.session_count)} Login"
      type == "immediate" ->
        "Immediate"
      type == "scheduled" ->
        "Scheduled"
    end
  end
end

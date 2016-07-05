defmodule Echo.NotificationStatistics do
  alias Echo.SentNotification
  alias Echo.Repo

  def stats_for(notification) do
    %{
      sent_count: sent_count(notification),
      seen_percent: seen_percent(notification),
      acknowledged_count: acknowledged_count(notification),
      acknowledged_percent: acknowledged_percent(notification),
      total_customer_count: echo_customer_count(notification)
    }
  end

  def sent_count(notification) do
    notification
    |> SentNotification.num_sent_notifications
    |> Repo.one
  end

  def seen_percent(notification) do
    case echo_customer_count(notification) do
      0 -> 0.0
      _ -> (sent_count(notification) / echo_customer_count(notification)) * 100
    end
  end

  def acknowledged_count(notification) do
    notification
    |> SentNotification.num_acknowledged_notifications
    |> Repo.one
  end

  def acknowledged_percent(notification) do
    case sent_count(notification) do
      0 -> 0.0
      _ -> (acknowledged_count(notification) / sent_count(notification)) * 100
    end
  end

  def echo_customer_count(notification) do
    Echo.Customer.total_count(notification)
    |> Repo.one
  end
end

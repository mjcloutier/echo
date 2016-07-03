defmodule Echo.NotificationStatistics do
  alias Echo.SentNotification
  alias Echo.Customer
  alias Echo.Repo

  def stats_for(notification) do
    %{
      sent_count: sent_count(notification),
      seen_percent: (sent_count(notification) / echo_customer_count) * 100,
      acknowledged_count: acknowledged_count(notification),
      acknowledged_percent: (acknowledged_count(notification) / echo_customer_count) * 100,
      total_customer_count: echo_customer_count
    }
  end

  def sent_count(notification) do
    notification
    |> SentNotification.num_sent_notifications
    |> Repo.one
  end

  def acknowledged_count(notification) do
    notification
    |> SentNotification.num_acknowledged_notifications
    |> Repo.one
  end

  def echo_customer_count do
    Echo.Customer.total_count
    |> Repo.one
  end
end

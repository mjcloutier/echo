require IEx
defmodule Echo.Api.V1.NotificationController do
  use Echo.Web, :controller
  require Logger

  alias Echo.Notification
  alias Echo.Customer

  plug :find_customer

  def index(conn, %{"user_id" => user_id}) do
    Logger.debug "Loggin some text for user_id: #{user_id}."

    notifications = Repo.all(Notification)
    render(conn, "index.json", notifications: notifications)
  end

  defp find_customer(conn, _) do
    case conn.params["user_id"] do
      nil -> conn |> render_error
      _   -> conn |> fetch_or_build_customer
    end
  end

  defp fetch_or_build_customer(conn) do
    customer = case Repo.get_by(Customer, app_user_id: conn.params["user_id"]) do
      nil -> Repo.insert!(Customer.changeset(%Customer{}, %{ app_user_id: conn.params["user_id"] }))
      customer -> customer
    end
    assign(conn, :customer, customer)
  end

  defp render_error(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Must provide a user_id."})
    |> halt # Stop execution of further plugs, return response now
  end
end

defmodule Echo.SentNotification do
  use Echo.Web, :model

  schema "sent_notifications" do
    belongs_to :customer,     Echo.Customer
    belongs_to :notification, Echo.Notification
    field :acknowledged, :boolean, default: false

    timestamps
  end

  @required_fields ~w(notification_id customer_id acknowledged)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def notification_ids_for_customer(customer) do
    from sent in Echo.SentNotification,
         where: sent.customer_id == ^customer.id,
         select: sent.notification_id
  end

  def create(customer, notification) do
      Echo.Repo.insert!(changeset(%Echo.SentNotification{}, %{
         customer_id: customer.id,
         notification_id: notification.id
       }))
  end
end

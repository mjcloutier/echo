defmodule Echo.SentNotification do
  use Echo.Web, :model

  alias Echo.Repo
  alias Echo.Customer
  alias Echo.Notification
  alias Echo.SentNotification

  schema "sent_notifications" do
    belongs_to :customer,     Customer
    belongs_to :notification, Notification
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
    from sent in SentNotification,
         where: sent.customer_id == ^customer.id,
         where: sent.acknowledged == true,
         select: sent.notification_id
  end

  def create(customer, notification) do
      Repo.insert!(changeset(%SentNotification{}, %{
         customer_id: customer.id,
         notification_id: notification.id
       }))
  end

  def sent_notifications(notification) do
    from(s in SentNotification,
     join: n in assoc(s, :notification),
     where: s.notification_id == ^notification.id)
  end

  def acknowledged_notifications(notification) do
      from(s in SentNotification.sent_notifications(notification),
        where: s.acknowledged == true)
  end

  def num_sent_notifications(notification) do
    from(s in sent_notifications(notification),
     select: count(s.id))
  end

  def num_acknowledged_notifications(notification) do
    from(s in acknowledged_notifications(notification),
     select: count(s.id))
  end
end

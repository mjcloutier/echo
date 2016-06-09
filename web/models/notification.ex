defmodule Echo.Notification do
  use Echo.Web, :model

  alias Echo.Repo
  alias Echo.Notification
  alias Echo.SentNotification

  schema "notifications" do
    field :title, :string
    field :body, :string
    field :start_at, Ecto.DateTime
    field :end_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(title body)
  @optional_fields ~w(start_at end_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:title, min: 3)
  end

  def unread_for(customer) do
    notification_ids = Repo.all(SentNotification.notification_ids_for_customer(customer))
    Repo.all(from n in Notification, where: not n.id in ^notification_ids)
  end
end

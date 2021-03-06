defmodule Echo.Notification do
  use Echo.Web, :model

  alias Echo.Repo
  alias Echo.Application
  alias Echo.Notification
  alias Echo.SentNotification

  schema "notifications" do
    field :title, :string
    field :body, :string
    field :summary, :string
    field :session_count, :integer
    field :start_at, Ecto.Date
    field :end_at, Ecto.Date
    belongs_to :application, Application
    belongs_to :created_by, Echo.User

    has_many :sent_notifications, SentNotification
    timestamps
  end

  @required_fields ~w(title body application_id)
  @optional_fields ~w(summary start_at end_at session_count created_by_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:title, min: 3)
    |> foreign_key_constraint(:application_id)
  end

  def unread_for(application_id, customer, sign_in_count) do
    query = available_today(application_id, customer)
    query =
      case sign_in_count do
        nil -> from n in query, where: is_nil(n.session_count)
        count -> from n in query, where: n.session_count == ^count or is_nil(n.session_count)
      end
    Repo.all(query) |> Repo.preload(:created_by)
  end

  def available_today(app_id, customer) do
    today = :os.timestamp |> :calendar.now_to_datetime |> Ecto.DateTime.from_erl
    notification_ids = Repo.all(SentNotification.notification_ids_for_customer(customer))

    from n in Notification,
       where: not n.id in ^notification_ids,
       where: n.application_id == ^app_id,
       where: n.end_at   > ^today or is_nil(n.end_at),
       where: n.start_at <= ^today or is_nil(n.start_at)
  end
end

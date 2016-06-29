defmodule Echo.Application do
  use Echo.Web, :model

  alias Echo.Application
  alias Echo.Repo

  schema "applications" do
    field :name, :string
    field :app_key, :string
    field :app_secret, :string

    has_many :notifications, Echo.Notification

    timestamps
  end

  @required_fields ~w(name app_key app_secret)
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

  def available do
    from a in Application,
      select: {a.name, a.id},
      order_by: [asc: a.name]
  end
end

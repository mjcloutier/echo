defmodule Echo.Customer do
  use Echo.Web, :model

  alias Echo.Repo
  alias Echo.Customer

  schema "customers" do
    field :app_user_id, :string
    belongs_to :application, Echo.Application

    timestamps
  end

  @required_fields ~w(app_user_id application_id)
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

  def find_or_create(application_id, app_user_id) do
    case Repo.get_by(Customer, app_user_id: app_user_id) do
      nil -> Repo.insert!(Customer.changeset(%Customer{}, %{ application_id: application_id, app_user_id: app_user_id }))
      customer -> customer
    end
  end
end

defmodule Echo.Repo do
  use Ecto.Repo, otp_app: :echo
  use Scrivener, page_size: 10
end

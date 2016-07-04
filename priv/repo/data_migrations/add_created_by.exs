alias Echo.Repo
alias Echo.Notification
alias Echo.User

import Ecto
import Ecto.Query
import Ecto.Changeset


# notifications 3,5,6,7

rachel = Repo.get!(User, 3)
IO.puts "Got Rachel"
n = Repo.get!(Notification, 3)
changeset = Notification.changeset(n, %{created_by_id: rachel.id})
Repo.update!(changeset)
IO.puts "1 down"

n2 = Repo.get!(Notification, 5)
changeset2 = Notification.changeset(n2, %{created_by_id: rachel.id})
Repo.update!(changeset2)
IO.puts "2 down"


alyssa = Repo.get!(User, 5)
IO.puts "Got Alyssa"
n3 = Repo.get!(Notification, 6)
changeset3 = Notification.changeset(n3, %{created_by_id: alyssa.id})
Repo.update!(changeset3)
IO.puts "3 down"

n4 = Repo.get!(Notification, 7)
changeset4 = Notification.changeset(n4, %{created_by_id: alyssa.id})
Repo.update!(changeset4)
IO.puts "Allll done"

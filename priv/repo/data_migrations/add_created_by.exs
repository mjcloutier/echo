alias Echo.Repo
alias Echo.Notification
alias Echo.User


# notifications 3,5,6,7

rachel = Repo.get!(User, 3)
n = Repo.get!(Notification, 3)
changeset = Notification.changeset(n, %{created_by_id: rachel.id})

n2 = Repo.get!(Repo.Notification, 5)
changeset = Notification.changeset(n2, %{created_by_id: rachel.id})


alyssa = Repo.get!(User, 5)
n3 = Repo.get!(Notification, 6)
changeset = Notification.changeset(n3, %{created_by_id: alyssa.id})

n4 = Repo.get!(Repo.Notification, 7)
changeset = Notification.changeset(n4, %{created_by_id: alyssa.id})

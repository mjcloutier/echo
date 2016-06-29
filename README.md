# Echo

[![CircleCI](https://circleci.com/gh/rtroxler/echo/tree/master.svg?style=svg)](https://circleci.com/gh/rtroxler/echo/tree/master)

To get started, you'll need Erlang 18+ and Elixir 1.3.0 installed.

You can _probably_ get by with just using homebrew for these.
  * `brew install erlang`
  * `brew install elixir`

To start the Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To integrate with Echo's notification API, you'll need to create an Application:
  1. Click the settings icon on the left nav (it's right above the peace sign ✌)
  2. Applications : View/Manage
  3. New Application
  4. After you create the application, click View/Edit to find the App ID and App Secret

With the Id and Secret, you should be able to call the API like so:

  `http://localhost:4000/api/v1/notifications?user_id=[SOME USER ID]&app_id=[YOUR APP ID]&app_secret=[YOUR APP SECRET]`


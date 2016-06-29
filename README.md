# Echo

[![CircleCI](https://circleci.com/gh/rtroxler/echo/tree/master.svg?style=svg)](https://circleci.com/gh/rtroxler/echo/tree/master)

## Setup
To get started, you'll need Erlang 18+ and Elixir 1.3.0 installed.

You can _probably_ get by with just using homebrew for these.
  * `brew install erlang`
  * `brew install elixir`

To start the Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## OAuth

  The OAuth login should work out of the box, but it requires a "@rednovalabs.com" email.


## Notification API

To integrate with Echo's notification API, you'll need to create an Application:
  1. Click the settings icon on the left nav (it's right above the peace sign ✌)
  2. Applications : View/Manage
  3. New Application
  4. After you create the application, click View/Edit to find the App ID and App Secret

With the Id and Secret, you should be able to call the API like so:

  `GET http://localhost:4000/api/v1/notifications?user_id=[SOME_USER_ID]&app_id=[YOUR_APP_ID]&app_secret=[YOUR_APP_SECRET]`

The user_id can theoretically be any string, but if you want the response to behave as expected it should probably be a user's id
of some sort

To prevent a notification from showing for a certain user after it's been sent, the notification has to be acknowledged.
You can acknowledge a notification like so:

  `PUT http://localhost:4000/api/v1/notifications/[NOTIFICATION_ID]`

with a body of:
  ```
  {
    user_id: [USER_ID],
    app_id: [APP_ID],
    app_secret: [APP_SECRET]
  }
  ```


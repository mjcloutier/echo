# Echo

[![CircleCI](https://circleci.com/gh/rtroxler/echo/tree/master.svg?style=svg)](https://circleci.com/gh/rtroxler/echo/tree/master)

### Setup
To get started, you'll need Erlang 18+ and Elixir 1.3.0 installed.

You can _probably_ get by with just using homebrew for these.
  * `brew install erlang`
  * `brew install elixir`

To start the Phoenix app:

  * Install dependencies with `mix deps.get`
  * Copy the `config/dev.secret.exs.example` file to `config/dev.secret.exs`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### OAuth

  The OAuth login should work out of the box, but it requires you to login to a "@rednovalabs.com" email.


### Notification API

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

### SSL 

If the application you're trying to integrate with uses SSL, you'll likely get a Mixed Content error when integrating with Echo if you don't also set up Echo to use SSL.

To use SSL, you'll want to add the following blocks to `config/dev.secret.exs`:
 ```
 config :echo, Echo.Endpoint,
  https: [ port: 4443,
    otp_app: :echo,
    keyfile: "priv/keys/localhost.key",
    certfile: "priv/keys/localhost.cert"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]
  
 config :echo, Echo,
  valid_cors_domains: ["https://fms-dev.rednovalabs.net"] # Or your dev url
 
 config :echo, Echo.Google,
  client_id: "729002142760-04tsuh7hav6demmova0vpmhkdl0ahd47.apps.googleusercontent.com",
  client_secret: "uF7VeT_BObOj2jXUaAu504aP",
  redirect_uri: "https://localhost:4443/auth/google/callback"
```

You'll also need to generate the localhost.key/cert files and move them to `priv/keys`:
```
# generate key
$ openssl genrsa -out localhost.key 2048
# generate cert
$ openssl req -new -x509 -key localhost.key -out localhost.cert -days 3650 -subj /CN=localhost
```

You'll now need to replace all usages of `http://localhost:4000` with `https://localhost:4443`

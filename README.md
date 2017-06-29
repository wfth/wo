# Wo

## Development

#### Install Tools

1. Install [Node Version Manager](https://github.com/creationix/nvm)
2. Install [direnv](https://direnv.net)
3. Install PostgreSQL, Elixir, and Phoenix

#### Install Application Dependencies

1. Install dependencies with `mix deps.get`
2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
3. Install Node.js dependencies with `npm install`
4. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Release Build

Each push to the git@github.com:wfth/wo.git master branch deploys through the Heroku `wo-ex` pipeline. `wo-ex-stage` is always up-to-date with the master branch code. The migrations do not run automatically. See http://www.phoenixframework.org/docs/heroku for deployment instructions.

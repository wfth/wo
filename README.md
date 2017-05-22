# Wo

## Development

1. Install PostgreSQL, Elixir, and Phoenix
3. Install dependencies with `mix deps.get`
4. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
5. Install Node.js dependencies with `npm install`
6. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Release Build

This project implements the approach described at https://shovik.com/blog/8-deploying-phoenix-apps-with-docker in order to create a production-ready Docker image.

Install Docker. Then the release build can be created by:
```
mix docker.build
mix docker.release
```

See the release image run but note that it cannot connect to any database:
```
docker run -it --rm -p 8080:8080 -e PORT=8080 -e HOST=localhost -e DB_HOST=localhost -e DB_NAME=wo_dev -e DB_USER=postgres -e DB_PASSWORD=postgres -e SECRET_KEY_BASE='somethingsecret' wfth/wo:release foreground
```

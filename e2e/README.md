# End-to-end Tests

This Node package uses Cypress to execute end-to-end browser tests against the Phoenix application.

## Getting Started

```sh
# from the root of the project
npm install --prefix e2e
```

## Running the Tests

**Note**: These tests rely on the seed data in `priv/repo/seeds.exs`. Make sure you've run `bin/setup.sh` or `mix ecto.setup` before running the tests.

Run the server:

```sh
mix phx.server
```

In a separate terminal, run the e2e tests:

```sh
npm run cy:open --prefix e2e
```

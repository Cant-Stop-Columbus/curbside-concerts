# End-to-end Tests

This Node package uses Cypress to execute end-to-end browser tests against the Phoenix application.

## Getting Started

```sh
# from the root of the project
npm install --prefix e2e
```

## Running the Tests

Set up:

```sh
docker-compose up -d
# seed data for the tests to use
mix run priv/repo/seeds.exs
```

Run the server:

```sh
mix phx.server
```

In a separate terminal, run the e2e tests:

```sh
npm run cy:open --prefix e2e
```

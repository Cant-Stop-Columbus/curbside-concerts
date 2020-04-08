# This seed file should be run before executing the Cypress e2e tests.
# It generates a test user in the test database.

# Seed files should NOT be applied to the production database.

CurbsideConcerts.Accounts.create_user(%{
  username: "cypress",
  password: "password"
})

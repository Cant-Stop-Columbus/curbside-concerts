const dangerAlert = () => cy.get(".alert-danger");
const heading = () => cy.get("h2");
const usernameField = () => cy.get('input[name="session[username]"]');
const passwordField = () => cy.get('input[name="session[password]"]');
const submitButton = () => cy.get('button[type="submit"]');

class SignInPage {
	visit() {
		cy.visit("/sign-in");
	}

	assert() {
		heading().should("contain.text", "Sign In");
	}

	assertAuthAlert() {
		dangerAlert().should(
			"contain.text",
			"You need to be signed in to access that page."
		);
	}

	fillInUsername(username) {
		usernameField().clear().type(username);
	}

	fillInPassword(password) {
		passwordField().clear().type(password);
	}

	clickSubmit() {
		submitButton().click();
	}
}

export default new SignInPage();

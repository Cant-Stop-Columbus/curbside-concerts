import layout from "./layout";

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
		layout.assertErrorAlert("You need to be signed in to access that page.");
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

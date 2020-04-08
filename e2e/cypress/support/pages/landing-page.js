const heading = () => cy.get("h1");
const sessionCard = (name) => cy.get(".session-card").contains(name);
const alertInfo = () => cy.get(".alert.alert-info");

class LandingPage {
	visit() {
		cy.visit("/");
	}

	assert() {
		heading().should("have.text", "Know someone feeling down?");
	}

	clickSession(sessionName) {
		sessionCard(sessionName).click();
	}

	assertRequestSuccessAlert(nomineeName) {
		alertInfo().should(
			"contain.text",
			`Thank you for submitting a concert request for ${nomineeName}!`
		);
	}
}

export default new LandingPage();

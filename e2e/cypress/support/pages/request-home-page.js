const heading = () => cy.get("h1");
const sessionCard = (name) => cy.get(".session-card").contains(name);
const alertInfo = () => cy.get(".alert.alert-info");

class RequestHomePage {
	visit() {
		cy.visit("/");
	}

	assert() {
		heading().should(
			"have.text",
			"Send a live curbside concert, for your quarantined loved ones"
		);
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

export default new RequestHomePage();

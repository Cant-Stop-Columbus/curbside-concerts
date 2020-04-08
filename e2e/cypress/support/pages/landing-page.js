const heading = () => cy.get("h1");
const alertInfo = () => cy.get(".alert.alert-info");
const requestConcertButton = () => cy.contains("REQUEST A CONCERT");

class LandingPage {
	visit() {
		cy.visit("/");
	}

	assert() {
		heading().should("have.text", "Know someone feeling down?");
	}

	clickRequestConcertButton() {
		requestConcertButton().click();
	}

	assertRequestSuccessAlert(nomineeName) {
		alertInfo().should(
			"contain.text",
			`Thank you for submitting a concert request for ${nomineeName}!`
		);
	}
}

export default new LandingPage();

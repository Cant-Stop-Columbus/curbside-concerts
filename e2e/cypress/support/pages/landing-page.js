const heading = () => cy.get("h1");
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
}

export default new LandingPage();

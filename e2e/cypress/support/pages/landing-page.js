const heading = () => cy.get("h1");
const requestConcertButton = () => cy.contains("REQUEST A CONCERT");

class LandingPage {
	visit() {
		cy.visit("/");
	}

	assert() {
		heading().should(
			"have.text",
			"Is there a Senior Citizen you know who needs to feel some love and connection right now?"
		);
	}

	clickRequestConcertButton() {
		requestConcertButton().click();
	}
}

export default new LandingPage();

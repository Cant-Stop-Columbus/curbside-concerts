const heading = () => cy.get("h1");
const requestConcertButton = () => cy.contains("REQUEST A CONCERT");

class LandingPage {
	visit() {
		cy.visit("/");
	}

	assert() {
		heading().should(
			"have.text",
			"Who do you want to celebrate as a Hero in 2020?"
		);
	}

	clickRequestConcertButton() {
		requestConcertButton().click();
	}
}

export default new LandingPage();

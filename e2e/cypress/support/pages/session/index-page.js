const heading = () => cy.get("h1");
const newSessionLink = () => cy.contains("Create a new session");
const editSessionLink = (sessionName) =>
	cy.contains(sessionName).parent(".card").contains("Edit");

class SessionIndexPage {
	visit() {
		cy.visit("/session");
	}

	assert() {
		heading().should("contain.text", "Sessions");
	}

	clickNewSessionLink() {
		newSessionLink().click();
	}

	clickEditLink(sessionName) {
		editSessionLink(sessionName).click();
	}
}

export default new SessionIndexPage();

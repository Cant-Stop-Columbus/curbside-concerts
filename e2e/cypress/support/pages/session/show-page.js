import layout from "./../layout";

const heading = () => cy.get("h1");
const backLink = () => cy.contains("Back");

class SessionShowPage {
	assert(sessionName) {
		heading().should("contain.text", "View Session");
		cy.contains(sessionName).should("exist");
	}

	assertCreateSuccessAlert() {
		layout.assertInfoAlert("Session created successfully.");
	}

	assertUpdateSuccessAlert() {
		layout.assertInfoAlert("Session updated successfully.");
	}

	clickBackLink() {
		backLink().click();
	}
}

export default new SessionShowPage();

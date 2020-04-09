import layout from "./../layout";

const heading = () => cy.get("h1");
const backLink = () => cy.contains("Back");

class GenreShowPage {
	assert(sessionName) {
		heading().should("contain.text", "View Genre");
		cy.contains(sessionName).should("exist");
	}

	assertCreateSuccessAlert() {
		layout.assertInfoAlert("Genre created successfully.");
	}

	assertUpdateSuccessAlert() {
		layout.assertInfoAlert("Genre updated successfully.");
	}

	clickBackLink() {
		backLink().click();
	}
}

export default new GenreShowPage();

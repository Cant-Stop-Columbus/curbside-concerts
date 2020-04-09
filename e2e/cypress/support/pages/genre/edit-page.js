const heading = () => cy.get("h1");
const nameField = () => cy.get('input[name="genre[name]"]');
const submitButton = () => cy.contains("SUBMIT");

class GenreEditPage {
	assert() {
		heading().should("contain.text", "Edit Genre");
	}

	fillInNameField(name) {
		nameField().clear().type(name);
	}

	fillInDescriptionField(description) {
		descriptionField().clear().type(description);
	}

	clickSubmit() {
		submitButton().click();
	}
}

export default new GenreEditPage();

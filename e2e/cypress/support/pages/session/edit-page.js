const heading = () => cy.get("h1");
const nameField = () => cy.get('input[name="session[name]"]');
const descriptionField = () => cy.get('textarea[name="session[description]"]');
const submitButton = () => cy.contains("SUBMIT");

class SessionEditPage {
	assert() {
		heading().should("contain.text", "Edit Session");
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

export default new SessionEditPage();

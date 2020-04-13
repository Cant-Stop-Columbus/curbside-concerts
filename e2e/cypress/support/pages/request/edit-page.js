const heading = () => cy.get("h1");
const legacyAddressField = () =>
	cy.get('input[name="request[nominee_address]"');
const submitButton = () => cy.contains("SUBMIT");

class RequestPage {
	assert() {
		heading().should("contain.text", "Edit Request");
	}

	fillInLegacyAddressField(address) {
		legacyAddressField().clear().type(address);
	}

	clickSubmitButton() {
		submitButton().click();
	}
}

export default new RequestPage();

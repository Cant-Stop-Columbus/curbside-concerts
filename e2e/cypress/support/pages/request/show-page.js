import layout from "./../layout";

const heading = () => cy.get("h1");

class RequestShowPage {
	assert(specialMessage) {
		heading().should("contain.text", "View Request");
		cy.contains(specialMessage).should("exist");
	}

	assertAddress(address) {
		cy.contains(address).should("exist");
	}

	assertEditSuccessMessage() {
		layout.assertInfoAlert("Request updated successfully.");
	}
}

export default new RequestShowPage();

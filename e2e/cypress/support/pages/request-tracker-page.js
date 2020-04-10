import layout from "./layout";

class RequestTrackerPage {
	assert(requesterName) {
		cy.contains(`Track your concert request progress here, ${requesterName}.`);
	}

	assertRequestSuccessAlert(nomineeName) {
		layout.assertInfoAlert(
			`Thank you for submitting a concert request for ${nomineeName}!`
		);
	}

	assertCancelRequestLink() {
		cy.get("a#cancel_request").should("contain.text", "Cancel Request");
	}

	clickCancelRequest() {
		cy.get("a#cancel_request").click();
	}
}

export default new RequestTrackerPage();

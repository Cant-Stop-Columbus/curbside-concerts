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
}

export default new RequestTrackerPage();

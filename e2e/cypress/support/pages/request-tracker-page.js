const alertInfo = () => cy.get(".alert.alert-info");

class RequestTrackerPage {
	assert(requesterName) {
		cy.contains(`Track your concert request progress here, ${requesterName}.`);
	}

	assertRequestSuccessAlert(nomineeName) {
		alertInfo().should(
			"contain.text",
			`Thank you for submitting a concert request for ${nomineeName}!`
		);
	}
}

export default new RequestTrackerPage();

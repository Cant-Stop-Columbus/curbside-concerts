const heading = () => cy.get("h1");
const requestCard = (specialRequest) =>
	cy.get(".card").contains(specialRequest).parent(".card");

class GigsPage {
	visit() {
		cy.visit("/gigs");
	}

	assert() {
		heading().should("contain.text", "All requests");
	}

	assertRequest(nomineeName, requesterName, specialMessage) {
		const request = requestCard(specialMessage);

		request
			.should("contain.text", nomineeName)
			.and("contain.text", requesterName);
	}
}

export default new GigsPage();

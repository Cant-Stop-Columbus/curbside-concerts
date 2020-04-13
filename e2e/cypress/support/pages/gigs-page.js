const heading = () => cy.get("h1");
const requestCard = (specialRequest) =>
	cy.get(".card").contains(specialRequest).parent(".card");

class GigsPage {
	visit() {
		cy.visit("/gigs");
	}

	assert() {
		heading().should("contain.text", "All requests (0)");
	}

	assertRequest(nomineeName, requesterName, specialMessage, genres) {
		const request = requestCard(specialMessage);

		request
			.should("contain.text", nomineeName)
			.and("contain.text", requesterName);
		genres.forEach((genre) => request.should("contain.text", genre));
	}
}

export default new GigsPage();

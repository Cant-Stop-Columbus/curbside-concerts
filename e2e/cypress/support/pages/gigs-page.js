const heading = () => cy.get("h1");
const requestCards = () => cy.get("card");
const requestCard = (specialMessage) =>
	cy.get(".card").contains(specialMessage).parent(".card");
const editRequestLink = (specialMessage) =>
	requestCard(specialMessage).contains("Edit");
const archiveRequestLink = (specialMessage) =>
	requestCard(specialMessage).contains("Archive this Request");
const offMissionRequestLink = (specialMessage) =>
	requestCard(specialMessage).contains("Mark as Off-Mission");
const receiveRequestLink = (specialMessage) =>
	requestCard(specialMessage).contains("Mark as Received");

const offMissionNavLink = () => cy.contains("Off-Mission");

class GigsPage {
	visit() {
		cy.visit("/gigs");
	}

	assert() {
		heading().should("contain.text", "All requests");
	}

	assertOffMissionView() {
		heading().should("contain.text", "All Off-mission requests");
	}

	assertRequest(nomineeName, requesterName, specialMessage, genres) {
		const request = requestCard(specialMessage);

		request
			.should("contain.text", nomineeName)
			.and("contain.text", requesterName);
		genres.forEach((genre) => request.should("contain.text", genre));
	}

	assertArchiveConfirmationPopUp() {
		cy.on("window:confirm", (str) => {
			expect(str).to.eq("Are you sure?");
			return true;
		});
	}

	refuteRequest(specialMessage) {
		requestCards().should("not.contain.text", specialMessage);
	}

	clickRequestEditLink(specialMessage) {
		editRequestLink(specialMessage).click();
	}

	clickRequestArchiveLink(specialMessage) {
		archiveRequestLink(specialMessage).click();
	}

	clickRequestOffMissionLink(specialMessage) {
		offMissionRequestLink(specialMessage).click();
	}

	clickRequestReceivedLink(specialMessage) {
		receiveRequestLink(specialMessage).click();
	}

	clickOffMissionNavLink() {
		offMissionNavLink().click();
	}
}

export default new GigsPage();

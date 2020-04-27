import layout from "./../layout";

const heading = () => cy.get("h1");
const newSessionLink = () => cy.contains("Create a new session");
const archiveViewLink = () => cy.contains("Show archived sessions");
const activeViewLink = () => cy.contains("Show active sessions");
const sessionCards = (name) => cy.get(".card");
const sessionCard = (name) => cy.contains(name).parent(".card");
const editSessionLink = (name) => sessionCard(name).contains("Edit");
const archiveSessionLink = (name) =>
	sessionCard(name).contains("Archive this Session");

class SessionIndexPage {
	visit() {
		cy.visit("/session");
	}

	assertActiveSessionView() {
		heading()
			.should("contain.text", "Sessions")
			.and("not.contain.text", "Archived");
	}

	assertArchivedSessionView() {
		heading().should("contain.text", "Archived Sessions");
	}

	assertSession(name) {
		sessionCard(name).should("exist");
	}

	refuteSession(name) {
		sessionCards().should("not.contain.text", name);
	}

	assertArchiveConfirmationPopUp() {
		cy.on("window:confirm", (str) => {
			expect(str).to.eq("Are you sure?");
			return true;
		});
	}

	assertArchiveSuccessAlert() {
		layout.assertInfoAlert("Session archived successfully.");
	}

	clickNewSessionLink() {
		newSessionLink().click();
	}

	clickArchiveViewLink() {
		archiveViewLink().click();
	}

	clickActiveViewLink() {
		activeViewLink().click();
	}

	clickEditSessionLink(name) {
		editSessionLink(name).click();
	}

	clickArchiveSessionLink(name) {
		archiveSessionLink(name).click();
	}
}

export default new SessionIndexPage();

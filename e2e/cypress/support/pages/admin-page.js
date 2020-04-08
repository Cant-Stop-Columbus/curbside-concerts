const gigsLink = () => cy.contains("View Gigs");
const heading = () => cy.get("h1");
const infoAlert = () => cy.get(".alert-info");
const signOutLink = () => cy.contains("Sign Out");

class AdminPage {
	visit() {
		cy.visit("/admin");
	}

	assert() {
		heading().should("contain.text", "Admin Page");
	}

	assertSignInSuccessAlert() {
		infoAlert().should("contain.text", "Signed in successfully.");
	}

	clickGigsLink() {
		gigsLink().click();
	}

	assertGigsLink() {
		gigsLink().should("exist");
	}

	refuteGigsLink() {
		gigsLink().should("not.exist");
	}

	clickSignOutLink() {
		signOutLink().click();
	}
}

export default new AdminPage();

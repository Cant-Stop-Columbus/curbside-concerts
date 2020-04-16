import layout from "./layout";

const gigsLink = () => cy.contains("All");
const heading = () => cy.get("h1");
const signOutLink = () => cy.contains("Sign Out");

class AdminPage {
	visit() {
		cy.visit("/admin");
	}

	assert() {
		heading().should("contain.text", "Admin Page");
	}

	assertSignInSuccessAlert() {
		layout.assertInfoAlert("Signed in successfully.");
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

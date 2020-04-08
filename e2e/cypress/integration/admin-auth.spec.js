import { adminPage, gigsPage, signInPage } from "../support/pages";

describe("Admin Login", () => {
	it("Should not be able to view /gigs page without signing in.", () => {
		gigsPage.visit();

		signInPage.assert();
		signInPage.assertAuthAlert();
	});

	it("Should be able to view /gigs page after signing in.", () => {
		signInPage.visit();

		signInPage.fillInUsername("cypress");
		signInPage.fillInPassword("password");
		signInPage.clickSubmit();

		adminPage.assert();
		adminPage.assertSignInSuccessAlert();
		adminPage.clickGigsLink();

		gigsPage.assert();
	});

	it("Should be able to sign out.", () => {
		cy.login();
		adminPage.visit();
		adminPage.assertGigsLink();

		adminPage.clickSignOutLink();

		adminPage.refuteGigsLink();
	});
});

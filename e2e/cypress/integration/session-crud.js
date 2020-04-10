import faker from "faker";
import {
	sessionIndexPage,
	sessionNewPage,
	sessionShowPage,
	sessionEditPage,
	signInPage,
} from "./../support/pages";

const sessionData = {
	name: faker.lorem.sentence(),
	description: faker.lorem.paragraph(),
};

describe("Session CRUD", () => {
	it("should not be available to unauthenticated users.", () => {
		sessionIndexPage.visit();

		signInPage.assert();
		signInPage.assertAuthAlert();
	});

	it("should be able to create a new session", () => {
		cy.login();

		sessionIndexPage.visit();
		sessionIndexPage.clickNewSessionLink();

		sessionNewPage.assert();

		sessionNewPage.fillInNameField(sessionData.name);
		sessionNewPage.fillInDescriptionField(sessionData.description);
		sessionNewPage.clickSubmit();

		sessionShowPage.assert(sessionData.name);
		sessionShowPage.assertCreateSuccessAlert();
	});

	it("should be able to update a session", () => {
		cy.login();

		sessionIndexPage.visit();
		sessionIndexPage.clickEditSessionLink(sessionData.name);

		sessionEditPage.assert();

		// update sessionData.name
		sessionData.name = faker.lorem.sentence();
		sessionEditPage.fillInNameField(sessionData.name);
		sessionEditPage.clickSubmit();

		sessionShowPage.assert(sessionData.name);
		sessionShowPage.assertUpdateSuccessAlert();
		sessionShowPage.clickBackLink();

		sessionIndexPage.assertActiveSessionView();
		sessionIndexPage.assertSession(sessionData.name);
	});

	it("should be able to archive a session", () => {
		cy.login();

		sessionIndexPage.visit();
		sessionIndexPage.assertActiveSessionView();

		sessionIndexPage.assertArchiveConfirmationPopUp();
		sessionIndexPage.assertSession(sessionData.name);
		sessionIndexPage.clickArchiveSessionLink(sessionData.name);

		sessionIndexPage.assertArchiveSuccessAlert();
		sessionIndexPage.refuteSession(sessionData.name);

		sessionIndexPage.clickArchiveViewLink();
		sessionIndexPage.assertArchivedSessionView();
		sessionIndexPage.assertSession(sessionData.name);

		sessionIndexPage.clickActiveViewLink();
		sessionIndexPage.assertActiveSessionView();
		sessionIndexPage.refuteSession(sessionData.name);
	});
});

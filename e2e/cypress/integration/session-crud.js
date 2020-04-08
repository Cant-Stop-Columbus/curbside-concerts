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

const updatedSessionData = {
	name: faker.lorem.sentence(),
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
		sessionIndexPage.clickEditLink(sessionData.name);

		sessionEditPage.assert();

		sessionEditPage.fillInNameField(updatedSessionData.name);
		sessionEditPage.clickSubmit();

		sessionShowPage.assert(updatedSessionData.name);
		sessionShowPage.assertUpdateSuccessAlert();
		sessionShowPage.clickBackLink();

		sessionIndexPage.assert();
	});
});

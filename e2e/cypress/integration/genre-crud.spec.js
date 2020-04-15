import faker from "faker";
import {
	genreIndexPage,
	genreNewPage,
	genreShowPage,
	genreEditPage,
	signInPage,
} from "../support/pages";

const genreData = {
	name: faker.company.companyName(),
};

describe("Genre CRUD", () => {
	it("should not be available to unauthenticated users.", () => {
		genreIndexPage.visit();

		signInPage.assert();
		signInPage.assertAuthAlert();
	});

	it("should be able to create a new genre", () => {
		cy.login();

		genreIndexPage.visit();
		genreIndexPage.clickNewGenreLink();

		genreNewPage.assert();

		genreNewPage.fillInNameField(genreData.name);
		genreNewPage.clickSubmit();

		genreShowPage.assert(genreData.name);
		genreShowPage.assertCreateSuccessAlert();
	});

	it("should be able to update a genre", () => {
		cy.login();

		genreIndexPage.visit();
		genreIndexPage.clickEditLink(genreData.name);

		genreEditPage.assert();

		genreData.name = faker.company.companyName();
		genreEditPage.fillInNameField(genreData.name);
		genreEditPage.clickSubmit();

		genreShowPage.assert(genreData.name);
		genreShowPage.assertUpdateSuccessAlert();
		genreShowPage.clickBackLink();

		genreIndexPage.assert();
	});

	it("should archive a genre", () => {
		cy.login();

		genreIndexPage.assertArchiveConfirmationPopUp();

		genreIndexPage.visit();
		genreIndexPage.clickArchiveLink(genreData.name);

		genreIndexPage.refuteGenre(genreData.name);

		genreIndexPage.clickArchivedNavLink();
		genreIndexPage.assertGenre(genreData.name);
	});
});

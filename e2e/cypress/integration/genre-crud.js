import faker from "faker";
import {
	genreIndexPage,
	genreNewPage,
	genreShowPage,
	genreEditPage,
	signInPage,
} from "./../support/pages";

const genreData = {
	name: faker.company.companyName(),
};

const updatedGenreData = {
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

		genreEditPage.fillInNameField(updatedGenreData.name);
		genreEditPage.clickSubmit();

		genreShowPage.assert(updatedGenreData.name);
		genreShowPage.assertUpdateSuccessAlert();
		genreShowPage.clickBackLink();

		genreIndexPage.assert();
	});
});

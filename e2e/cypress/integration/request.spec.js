import faker from "faker";
import {
	gigsPage,
	landingPage,
	requestEditPage,
	requestFormPage,
	requestShowPage,
	requestTrackerPage,
} from "./../support/pages";

const genreData1 = {
	name: faker.lorem.words(3),
};

const genreData2 = {
	name: faker.lorem.words(2),
};

const requestData = {
	priority: true,
	adminNotes: faker.lorem.paragraph(),
	nomineeName: faker.name.findName(),
	contactPreference: "call_nominee",
	nomineePhone: faker.phone.phoneNumber('614-###-####'),
	genres: [genreData1.name, genreData2.name],
	nomineeStreetAddress: faker.address.streetAddress(),
	nomineeCity: faker.address.city(),
	nomineeZipCode: faker.address.zipCode("#####"),
	nomineeAddressNotes: faker.lorem.paragraph(),
	specialMessage: faker.lorem.paragraph(),
	requesterName: faker.name.findName(),
	requesterPhone: faker.phone.phoneNumber('614-###-####'),
	requesterEmail: faker.internet.email(),
};

describe("Request", () => {
	before(() => {
		cy.login();
		cy.createGenre(genreData1);
		cy.createGenre(genreData2);
		cy.logout();
	});

	after(() => {
		cy.login();
		cy.archiveGenre(genreData1);
		cy.archiveGenre(genreData2);
		cy.logout();
	});

	describe("Manage a submitted request as an authenticated admin user", () => {
		beforeEach(() => {
			cy.login();
		});

		it("should see request appear on /gigs page when logged in as admin", () => {
			gigsPage.visit();
			gigsPage.assertRequest(
				requestData.nomineeName,
				requestData.requesterName,
				requestData.specialMessage,
				requestData.genres
			);
		});

		it("should allow editing all request fields as an admin", () => {
			gigsPage.visit();
			gigsPage.clickRequestEditLink(requestData.specialMessage);

			requestEditPage.assert();

			requestFormPage.fillInAdminNotes(requestData.adminNotes);
			requestFormPage.checkPriority();

			requestFormPage.fillInNomineeName(requestData.nomineeName);
			requestFormPage.clickContactPreferenceOption(
				requestData.contactPreference
			);
			requestFormPage.fillInNomineePhone(requestData.nomineePhone);
			requestFormPage.fillInNomineeStreetAddress(requestData.nomineeStreetAddress);
			requestFormPage.fillInNomineeCity(requestData.nomineeCity);
			requestFormPage.fillInNomineeZipCode(requestData.nomineeZipCode);
			requestFormPage.fillInNomineeAddressNotes(requestData.nomineeAddressNotes);
			requestData.genres.forEach((genre) => {
				requestFormPage.clickGenreCheckbox(genre);
			});
			requestFormPage.fillInSpecialMessage(requestData.specialMessage);
			requestFormPage.fillInRequesterName(requestData.requesterName);
			requestFormPage.fillInRequesterEmail(requestData.requesterEmail);
			requestFormPage.fillInRequesterPhone(requestData.requesterPhone);

			requestEditPage.clickSubmitButton();

			requestShowPage.assert(requestData.specialMessage);
			requestShowPage.assertAddress(`${requestData.nomineeStreetAddress} ${requestData.nomineeCity} ${requestData.nomineeZipCode}`);
		});

		it("should be able to mark a request as off-mission, then back", () => {
			gigsPage.visit();

			// mark a request off-mission
			gigsPage.clickRequestOffMissionLink(requestData.specialMessage);

			// the request should appear on the off-mission view
			gigsPage.clickOffMissionNavLink();
			gigsPage.assertOffMissionView();
			gigsPage.assertRequest(
				requestData.nomineeName,
				requestData.requesterName,
				requestData.specialMessage,
				requestData.genres
			);

			// mark a request as received (undo the off-mission state)
			gigsPage.clickRequestReceivedLink(requestData.specialMessage);

			// the request should disappear from the off-mission view
			gigsPage.refuteRequest();
		});

		it("should be able to archive a request as an admin", () => {
			gigsPage.assertArchiveConfirmationPopUp();

			gigsPage.visit();
			gigsPage.clickRequestArchiveLink(requestData.specialMessage);

			gigsPage.refuteRequest(requestData.specialMessage);
		});
	});
});

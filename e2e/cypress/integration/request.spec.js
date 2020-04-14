import faker from "faker";
import {
	gigsPage,
	landingPage,
	requestEditPage,
	requestFormPage,
	requestShowPage,
	requestTrackerPage,
} from "./../support/pages";

const requestData = {
	nomineeName: faker.name.findName(),
	contactPreference: "call_nominee",
	nomineePhone: faker.phone.phoneNumberFormat(),
	genres: ["Country", "Marching Band"],
	nomineeStreetAddress: faker.address.streetAddress(),
	nomineeCity: faker.address.city(),
	nomineeZipCode: faker.address.zipCode(),
	nomineeAddressNotes: faker.lorem.paragraph(),
	specialMessage: faker.lorem.paragraph(),
	requesterName: faker.name.findName(),
	requesterPhone: faker.phone.phoneNumberFormat(),
	requesterEmail: faker.internet.email(),
};

describe("Request", () => {
	describe("Submit a request for a concert as an unauthenticated user.", () => {
		it("Should submit a new request", () => {
			landingPage.visit();
			landingPage.assert();

			landingPage.clickRequestConcertButton();
			requestFormPage.assert();

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

			requestFormPage.clickSubmit();

			requestTrackerPage.assert(requestData.requesterName);
			requestTrackerPage.assertRequestSuccessAlert(requestData.nomineeName);
		});
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
				["Country", "Marching Band"]
			);
		});

		it("should be able to edit the legacy address of a request as an admin", () => {
			gigsPage.visit();
			gigsPage.clickRequestEditLink(requestData.specialMessage);

			requestEditPage.assert();

			const streetAddress = faker.address.streetAddress();
			const city = faker.address.city();
			const zipCode = faker.address.zipCode();

			requestEditPage.fillInNomineeStreetAddress(streetAddress);
			requestEditPage.fillInNomineeCity(city);
			requestEditPage.fillInNomineeZipCode(zipCode);
			requestEditPage.fillInNomineeAddressNotes(faker.lorem.paragraph());

			requestEditPage.clickSubmitButton();

			requestShowPage.assert(requestData.specialMessage);
			requestShowPage.assertAddress(`${streetAddress} ${city} ${zipCode}`);
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

	describe("Cancel a concert request as the requester.", () => {
		it("should cancel an existing request", () => {
			requestFormPage.visit();

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

			requestFormPage.clickSubmit();

			requestTrackerPage.assertCancelRequestLink();

			requestTrackerPage.clickCancelRequest();
			requestFormPage.assert();

			requestFormPage.assertCancelRequestSuccessAlert(requestData.nomineeName);
		});
	});
});

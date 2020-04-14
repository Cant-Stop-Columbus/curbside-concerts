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
	describe("Submit a request for a concert.", () => {
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

		it("should see request appear on /gigs page when logged in as admin", () => {
			cy.login();

			gigsPage.visit();
			gigsPage.assertRequest(
				requestData.nomineeName,
				requestData.requesterName,
				requestData.specialMessage,
				["Country", "Marching Band"]
			);
		});

		it("should be able to edit the address of a request as an admin", () => {
			cy.login();

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

		it("should be able to archive a request as an admin", () => {
			cy.login();

			gigsPage.assertArchiveConfirmationPopUp();

			gigsPage.visit();
			gigsPage.clickRequestArchiveLink(requestData.specialMessage);

			gigsPage.refuteRequest(requestData.specialMessage);
		});
	});

	describe("Cancel a concert request", () => {
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

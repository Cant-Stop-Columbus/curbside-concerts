import faker from "faker";
import { gigsPage, landingPage, requestFormPage } from "./../support/pages";

const requestData = {
	nomineeName: faker.name.findName(),
	contactPreference: "call_nominee",
	nomineePhone: faker.phone.phoneNumberFormat(),
	song: "Hallelujah",
	nomineeAddress: buildFakeAddress(),
	specialMessage: faker.lorem.paragraph(),
	requesterName: faker.name.findName(),
	requesterPhone: faker.phone.phoneNumberFormat(),
};

function buildFakeAddress() {
	return `${faker.address.streetAddress()} ${faker.address.city()}, ${faker.address.state()} ${faker.address.zipCode()}`;
}

describe("Submit a request for a concert.", () => {
	it("Should submit a new request", () => {
		landingPage.visit();
		landingPage.assert();

		landingPage.clickRequestConcertButton();
		requestFormPage.assert();

		requestFormPage.fillInNomineeName(requestData.nomineeName);
		requestFormPage.clickContactPreferenceOption(requestData.contactPreference);
		requestFormPage.fillInNomineePhone(requestData.nomineePhone);
		requestFormPage.fillInNomineeAddress(requestData.nomineeAddress);
		requestFormPage.fillInSpecialMessage(requestData.specialMessage);
		requestFormPage.fillInRequesterName(requestData.requesterName);
		requestFormPage.fillInRequesterPhone(requestData.requesterPhone);

		requestFormPage.clickSubmit();

		landingPage.assert();
		landingPage.assertRequestSuccessAlert(requestData.nomineeName);
	});

	it("should see request appear on /gigs page when logged in as admin", () => {
		cy.login();

		gigsPage.visit();
		gigsPage.assertRequest(
			requestData.nomineeName,
			requestData.requesterName,
			requestData.specialMessage
		);
	});
});

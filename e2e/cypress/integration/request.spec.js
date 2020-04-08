import faker from "faker";
import { requestFormPage, landingPage } from "./../support/pages";

// See priv/repo/seeds.exs for the seeded musician / session data
const sessionData = {
	name: "Songs with Remington",
};

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

		landingPage.clickSession(sessionData.name);
		requestFormPage.assert(sessionData.name);

		requestFormPage.fillInNomineeName(requestData.nomineeName);
		requestFormPage.clickContactPreferenceOption(requestData.contactPreference);
		requestFormPage.fillInNomineePhone(requestData.nomineePhone);
		requestFormPage.selectSong(requestData.song);
		requestFormPage.fillInNomineeAddress(requestData.nomineeAddress);
		requestFormPage.fillInSpecialMessage(requestData.specialMessage);
		requestFormPage.fillInRequesterName(requestData.requesterName);
		requestFormPage.fillInRequesterPhone(requestData.requesterPhone);

		requestFormPage.clickSubmit();

		landingPage.assert();
		landingPage.assertRequestSuccessAlert(requestData.nomineeName);
	});
});

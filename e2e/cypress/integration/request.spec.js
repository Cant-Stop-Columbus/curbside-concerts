import faker from "faker";
import { requestFormPage, requestHomePage } from "./../support/pages";

// See priv/repo/seeds.exs for the seeded musician / session data
const sessionData = {
	name: "Songs with Remington",
};

const requestData = {
	nomineeName: faker.name.findName(),
	contactPreference: "call_nominee",
	nomineePhone: faker.phone.phoneNumberFormat().replace(/-/g, ""),
	song: "Hallelujah",
	nomineeAddress: buildFakeAddress(),
	specialMessage: faker.lorem.paragraph(),
	requesterName: faker.name.findName(),
	requesterPhone: faker.phone.phoneNumberFormat().replace(/-/g, ""),
};

function buildFakeAddress() {
	return `${faker.address.streetAddress()} ${faker.address.city()}, ${faker.address.state()} ${faker.address.zipCode()}`;
}

describe("Request", () => {
	it("Should submit a new request", () => {
		requestHomePage.visit();
		requestHomePage.assert();

		requestHomePage.clickSession(sessionData.name);
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

		requestHomePage.assert();
		requestHomePage.assertRequestSuccessAlert(requestData.nomineeName);
	});
});

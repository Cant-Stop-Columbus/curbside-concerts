const heading = () => cy.get("h2");
const nomineeNameField = () => cy.get('input[name="request[nominee_name]"]');
const nomineeContactPreferenceRadio = () =>
	cy.get('input[name="request[contact_preference]"]');
const nomineePhoneField = () => cy.get('input[name="request[nominee_phone]"]');
const nomineeSongField = () => cy.get('select[name="request[song]"]');
const nomineeAddressField = () =>
	cy.get('input[name="request[nominee_address]"]');
const specialMessageField = () =>
	cy.get('textarea[name="request[special_message]"]');
const requesterNameField = () =>
	cy.get('input[name="request[requester_name]"]');
const requesterPhoneField = () =>
	cy.get('input[name="request[requester_phone]"]');
const submitButton = () => cy.contains("Submit");

class RequestFormPage {
	visit() {
		cy.visit("/");
	}

	assert(sessionName) {
		heading().should("have.text", sessionName);
	}

	fillInNomineeName(name) {
		nomineeNameField().clear().type(name);
	}

	clickContactPreferenceOption(value) {
		nomineeContactPreferenceRadio().check(value).click();
	}

	fillInNomineePhone(phone) {
		nomineePhoneField().clear().type(phone);
	}

	selectSong(song) {
		nomineeSongField().select(song);
	}

	fillInNomineeAddress(address) {
		nomineeAddressField().clear().type(address);
	}

	fillInSpecialMessage(message) {
		specialMessageField().clear().type(message);
	}

	fillInRequesterName(name) {
		requesterNameField().clear().type(name);
	}

	fillInRequesterPhone(phone) {
		requesterPhoneField().clear().type(phone);
	}

	clickSubmit() {
		submitButton().click();
	}
}

export default new RequestFormPage();

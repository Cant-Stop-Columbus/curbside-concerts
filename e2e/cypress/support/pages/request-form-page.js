const heading = () => cy.get("h1");
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
const requesterEmailField = () =>
	cy.get('input[name="request[requester_email]"]');
const genreCheckbox = (label) =>
	cy.contains("label", label).within(() => {
		cy.get('input[name="request[genres][]"]');
	});
const submitButton = () => cy.contains("SUBMIT");

class RequestFormPage {
	visit() {
		cy.visit("/");
	}

	assert() {
		heading().should("have.text", "Request a concert");
	}

	fillInNomineeName(name) {
		nomineeNameField().clear().type(name);
	}

	clickContactPreferenceOption(value) {
		nomineeContactPreferenceRadio().check(value);
	}

	fillInNomineePhone(phone) {
		nomineePhoneField().clear().type(phone);
	}

	selectSong(song) {
		nomineeSongField().select(song);
	}

	clickGenreCheckbox(genre) {
		genreCheckbox(genre).check();
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

	fillInRequesterEmail(email) {
		requesterEmailField().clear().type(email);
	}

	clickSubmit() {
		submitButton().click();
	}
}

export default new RequestFormPage();

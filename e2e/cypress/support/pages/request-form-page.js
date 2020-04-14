import layout from "./layout";

const heading = () => cy.get("h1");
const nomineeNameField = () => cy.get('input[name="request[nominee_name]"]');
const nomineeContactPreferenceRadio = () =>
	cy.get('input[name="request[contact_preference]"]');
const nomineePhoneField = () => cy.get('input[name="request[nominee_phone]"]');
const nomineeSongField = () => cy.get('select[name="request[song]"]');
const nomineeStreetAddressField = () =>
	cy.get('input[name="request[nominee_street_address]"]');
const nomineeCityField = () =>
	cy.get('input[name="request[nominee_city]"]');
const nomineeZipCodeField = () =>
	cy.get('input[name="request[nominee_zip_code]"]');
const nomineeAddressNotesField = () =>
	cy.get('textarea[name="request[nominee_address_notes]"]');
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
		cy.visit("/request");
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

	fillInNomineeStreetAddress(streetAddress) {
		nomineeStreetAddressField().clear().type(streetAddress);
	}

	fillInNomineeCity(city) {
		nomineeCityField().clear().type(city);
	}

	fillInNomineeZipCode(zipcode) {
		nomineeZipCodeField().clear().type(zipcode);
	}

	fillInNomineeAddressNotes(notes) {
		nomineeAddressNotesField().clear().type(notes);
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

	assertCancelRequestSuccessAlert(nomineeName) {
		layout.assertInfoAlert(
			`The concert request for ${nomineeName} has been cancelled.`
		);
	}
}

export default new RequestFormPage();

const heading = () => cy.get("h1");
const nomineeStreetAddressField = () =>
	cy.get('input[name="request[nominee_street_address]"]');
const nomineeCityField = () =>
	cy.get('input[name="request[nominee_city]"]');
const nomineeZipCodeField = () =>
	cy.get('input[name="request[nominee_zip_code]"]');
const submitButton = () => cy.contains("SUBMIT");

class RequestPage {
	assert() {
		heading().should("contain.text", "Edit Request");
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

	clickSubmitButton() {
		submitButton().click();
	}
}

export default new RequestPage();

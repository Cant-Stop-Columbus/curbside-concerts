const infoAlert = () => cy.get(".alert.alert-info");
const errorAlert = () => cy.get(".alert.alert-danger");

class Layout {
	assertInfoAlert(message) {
		infoAlert().should("contain.text", message);
	}

	assertErrorAlert(message) {
		errorAlert().should("contain.text", message);
	}
}

export default new Layout();

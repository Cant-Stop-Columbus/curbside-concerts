import layout from "./../layout";

const heading = () => cy.get("h1");
const backLink = () => cy.contains("Back");

export default {
	assert: (name) => {
		heading().should("contain.text", "View Musician");
		cy.contains(name).should("exist");
	},
	assertCreateSuccessAlert: () => layout.assertInfoAlert("Musician created successfully."),
	assertUpdateSuccessAlert: () => layout.assertInfoAlert("Musician updated successfully."),
	clickBackLink: () => backLink().click(),
}

const heading = () => cy.get("h1");
const archivedNavLink = () => cy.contains("Show archived genres");
const genreCards = () => cy.get(".card");
const genreCard = (name) => cy.contains(name).parent(".card");
const newGenreLink = () => cy.contains("Create a new genre");
const editGenreLink = (name) =>
	cy.contains(name).parent(".card").contains("Edit");
const archiveGenreLink = (name) =>
	cy.contains(name).parent(".card").contains("Archive this Genre");

class GenreIndexPage {
	visit() {
		cy.visit("/genre");
	}

	assert() {
		heading().should("contain.text", "Genres");
	}

	assertGenre(name) {
		genreCard(name).should("exist");
	}

	refuteGenre(name) {
		genreCards().should("not.contain.text", name);
	}

	assertArchiveConfirmationPopUp() {
		cy.on("window:confirm", (str) => {
			expect(str).to.eq("Are you sure?");
			return true;
		});
	}

	clickArchivedNavLink() {
		archivedNavLink().click();
	}

	clickNewGenreLink() {
		newGenreLink().click();
	}

	clickEditLink(name) {
		editGenreLink(name).click();
	}

	clickArchiveLink(name) {
		archiveGenreLink(name).click();
	}
}

export default new GenreIndexPage();

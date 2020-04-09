const heading = () => cy.get("h1");
const newGenreLink = () => cy.contains("Create a new genre");
const editGenreLink = (genreName) =>
	cy.contains(genreName).parent(".card").contains("Edit");

class GenreIndexPage {
	visit() {
		cy.visit("/genre");
	}

	assert() {
		heading().should("contain.text", "Genres");
	}

	clickNewGenreLink() {
		newGenreLink().click();
	}

	clickEditLink(genreName) {
		editGenreLink(genreName).click();
	}
}

export default new GenreIndexPage();

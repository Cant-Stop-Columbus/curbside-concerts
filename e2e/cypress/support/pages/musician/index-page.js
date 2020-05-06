const heading = () => cy.get("h1");
const musicianCards = () => cy.get(".card");
const musicianCard = (name) => cy.contains(`Name: ${name}`).parent(".card");
const newMusicianLink = () => cy.contains("Add musician");
const editMusicianLink = (name) => cy.contains(`Name: ${name}`).parent(".card").contains("Edit");

export default {
  visit: () => cy.visit("/musician"),
  assert: () => heading().should("contain.text", "All musicians"),
  assertMusician: (name) => musicianCard(name).should("exist"),
  clickNewMusicianLink: () => newMusicianLink().click(),
  clickEditMusicianLink: (name) => editMusicianLink(name).click(),
};

// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

import { adminPage, signInPage, genreIndexPage, genreNewPage } from "./pages";

Cypress.Commands.add("logout", () => {
	adminPage.visit();
	adminPage.clickSignOutLink();
});

Cypress.Commands.add("login", () => {
	signInPage.visit();
	signInPage.fillInUsername("cypress");
	signInPage.fillInPassword("password");
	signInPage.clickSubmit();
});

Cypress.Commands.add("createGenre", ({ name: name }) => {
	genreIndexPage.visit();
	genreIndexPage.clickNewGenreLink();
	genreNewPage.fillInNameField(name);
	genreNewPage.clickSubmit();
});

Cypress.Commands.add("archiveGenre", ({ name: name }) => {
	genreIndexPage.visit();
	genreIndexPage.clickArchiveLink(name);
});

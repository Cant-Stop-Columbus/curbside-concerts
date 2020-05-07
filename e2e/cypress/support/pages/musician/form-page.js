const heading = () => cy.get("h1");
const nameField = () => cy.get('input[name="musician[name]"]');
const bioField = () => cy.get('textarea[name="musician[bio]"]');
const urlPathNameField = () => cy.get('input[name="musician[url_pathname]"]');
const sessionTitleField = () => cy.get('input[name="musician[default_session_title]"]');
const sessionDescriptionField = () => cy.get('textarea[name="musician[default_session_description]"]');
const facebookUrlField = () => cy.get('input[name="musician[facebook_url]"]');
const twitterUrlField = () => cy.get('input[name="musician[twitter_url]"]');
const instagramUrlField = () => cy.get('input[name="musician[instagram_url]"]');
const youtubeUrlField = () => cy.get('input[name="musician[youtube_url]"]');
const websiteUrlField = () => cy.get('input[name="musician[website_url]"]');
const cashAppUrlField = () => cy.get('input[name="musician[cash_app_url]"]');
const venmoUrlField = () => cy.get('input[name="musician[venmo_url]"]');
const paypalUrlField = () => cy.get('input[name="musician[paypal_url]"]');

const submitButton = () => cy.contains("SUBMIT");

const fillInField = (field, text) => field().clear().type(text);

export default {
  assertNew: () => heading().should('contain.text', 'New Musician'),
  assertEdit: () => heading().should('contain.text', 'Edit Musician'),
  clickSubmit: () => submitButton().click(),
  fillInNameField: (name) => fillInField(nameField, name),
  fillInBioField: (bio) => fillInField(bioField, bio),
  fillInUrlPathNameField: (pathname) => fillInField(urlPathNameField, pathname),
  fillInSessionTitleField: (title) => fillInField(sessionTitleField, title),
  fillInSessionDescriptionField: (description) => fillInField(sessionDescriptionField, description),
  fillInFaceBookUrlField: (url) => fillInField(facebookUrlField, url),
  fillInTwitterUrlField: (url) => fillInField(twitterUrlField, url),
  fillInInstagramUrlField: (url) => fillInField(instagramUrlField, url),
  fillInYoutubeUrlField: (url) => fillInField(youtubeUrlField, url),
  fillInWebsiteUrlField: (url) => fillInField(websiteUrlField, url),
  fillInCashAppUrlField: (url) => fillInField(cashAppUrlField, url),
  fillInVenmoUrlField: (url) => fillInField(venmoUrlField, url),
  fillInPaypalUrlField: (url) => fillInField(paypalUrlField, url),
}

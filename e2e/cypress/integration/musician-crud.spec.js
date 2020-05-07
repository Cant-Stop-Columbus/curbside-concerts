import faker from "faker";
import {
  musicianFormPage,
  musicianIndexPage,
  musicianShowPage,
  signInPage
} from "../support/pages";

describe("Musician CRUD", () => {
  describe("When unauthenticated", () => {
    it("the page should not be accessible.", () => {
      musicianIndexPage.visit();
  
      signInPage.assert();
      signInPage.assertAuthAlert();
    });
  });
  
  describe("When authenticated", () => {
    beforeEach(() => cy.login());

    const data = Object.freeze({
      name: faker.name.findName(),
      bio: faker.lorem.paragraph(),
      urlPathName: faker.name.firstName(),
      sessionTitle: faker.name.title(),
      sessionDescription: faker.lorem.paragraph(),
      facebookUrl: faker.internet.url(),
      twitterUrl: faker.internet.url(),
      instagramUrl: faker.internet.url(),
      youtubeUrl: faker.internet.url(),
      websiteUrl: faker.internet.url(),
      cashAppUrl: faker.internet.url(),
      venmoUrl: faker.internet.url(),
      paypalUrl: faker.internet.url(),
    })

    it("should be able to create a new musician", () => {
      musicianIndexPage.visit();
      musicianIndexPage.clickNewMusicianLink();

      musicianFormPage.assertNew();
      musicianFormPage.fillInNameField(data.name);
      musicianFormPage.fillInBioField(data.bio);
      musicianFormPage.fillInUrlPathNameField(data.urlPathName);
      musicianFormPage.fillInSessionTitleField(data.sessionTitle);
      musicianFormPage.fillInSessionDescriptionField(data.sessionDescription);
      musicianFormPage.fillInFaceBookUrlField(data.facebookUrl);
      musicianFormPage.fillInTwitterUrlField(data.twitterUrl);
      musicianFormPage.fillInInstagramUrlField(data.instagramUrl);
      musicianFormPage.fillInYoutubeUrlField(data.youtubeUrl);
      musicianFormPage.fillInWebsiteUrlField(data.websiteUrl);
      musicianFormPage.fillInCashAppUrlField(data.cashAppUrl);
      musicianFormPage.fillInVenmoUrlField(data.venmoUrl);
      musicianFormPage.fillInPaypalUrlField(data.paypalUrl);

      musicianFormPage.clickSubmit();

      musicianIndexPage.assert();
      musicianIndexPage.assertMusician(data.name);
    });

    it("should be able to update a new musician", () => {
      musicianIndexPage.visit();
      musicianIndexPage.clickEditMusicianLink(data.name);

      const newName = faker.name.findName();
      musicianFormPage.assertEdit();
      musicianFormPage.fillInNameField(newName);
      musicianFormPage.fillInBioField(data.bio);
      musicianFormPage.fillInUrlPathNameField(data.urlPathName);
      musicianFormPage.fillInSessionTitleField(data.sessionTitle);
      musicianFormPage.fillInSessionDescriptionField(data.sessionDescription);
      musicianFormPage.fillInFaceBookUrlField(data.facebookUrl);
      musicianFormPage.fillInTwitterUrlField(data.twitterUrl);
      musicianFormPage.fillInInstagramUrlField(data.instagramUrl);
      musicianFormPage.fillInYoutubeUrlField(data.youtubeUrl);
      musicianFormPage.fillInWebsiteUrlField(data.websiteUrl);
      musicianFormPage.fillInCashAppUrlField(data.cashAppUrl);
      musicianFormPage.fillInVenmoUrlField(data.venmoUrl);
      musicianFormPage.fillInPaypalUrlField(data.paypalUrl);

      musicianFormPage.clickSubmit();

      musicianShowPage.assert(newName);
      musicianShowPage.assertUpdateSuccessAlert();
    });
  });
});
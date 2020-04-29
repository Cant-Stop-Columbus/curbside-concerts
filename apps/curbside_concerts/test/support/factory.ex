defmodule CurbsideConcerts.Factory do
  alias CurbsideConcerts.Repo

  alias CurbsideConcerts.Accounts.User
  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Requests.Request

  def attrs(:musician) do
    %{
      first_name: Faker.Name.first_name(),
      last_name: Faker.Name.last_name(),
      bio: Faker.Lorem.Shakespeare.as_you_like_it(),
      url_pathname: Faker.Internet.user_name(),
      default_session_title: Faker.Name.name(),
      default_session_description: Faker.StarWars.quote(), 
      facebook_url: Faker.Internet.url(),
      twitter_url: Faker.Internet.url(),
      instagram_url: Faker.Internet.url(),
      website_url: Faker.Internet.url(),
      cash_app_url: Faker.Internet.url(),
      venmo_url: Faker.Internet.url(),
      paypal_url: Faker.Internet.url()
    }
  end

  def attrs(:session) do
    %{
      name: Faker.Lorem.sentence(),
      description: Faker.Lorem.paragraph()
    }
  end

  def attrs(:genre) do
    %{name: Faker.Food.dish()}
  end

  def attrs(:user) do
    %{
      username: Faker.Internet.user_name(),
      password: Faker.String.base64()
    }
  end

  def attrs(:request) do
    %{
      nominee_name: Faker.Name.name(),
      contact_preference: Faker.Util.pick(["call_nominee", "call_requester", "text_requester"]),
      nominee_phone: Faker.Phone.EnUs.phone(),
      nominee_street_address: Faker.Address.street_address(),
      nominee_city: Faker.Address.city(),
      nominee_zip_code: Faker.Address.En.zip_code(),
      nominee_address_notes: Faker.StarWars.quote(),
      special_message: Faker.Lorem.Shakespeare.as_you_like_it(),
      requester_name: Faker.Name.name(),
      requester_phone: Faker.Phone.EnUs.phone(),
      requester_email: Faker.Internet.email(),
      request_reason: Faker.Lorem.paragraph(1..2),
      nominee_description: Faker.Lorem.paragraph(1..2)
    }
  end

  def attrs(factory_name, attributes) do
    factory_name |> attrs() |> Map.merge(attributes)
  end

  def build(:musician) do
    struct(Musician, attrs(:musician))
  end

  def build(:session) do
    struct(
      Session,
      attrs(:session, %{
        musician: build(:musician)
      })
    )
  end

  def build(:genre) do
    struct(Genre, attrs(:genre))
  end

  def build(:user) do
    struct(User, attrs(:user))
  end

  def build(:request) do
    struct(
      Request,
      attrs(:request, %{
        genres: [build(:genre), build(:genre)]
      })
    )
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(:user) do
    %{password: password} = user_attrs = attrs(:user)

    # perform the bcrypt hashing of the password field
    inserted_user =
      %User{}
      |> User.changeset(user_attrs)
      |> Repo.insert!()

    %{inserted_user | password: password}
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert!(build(factory_name, attributes))
  end
end

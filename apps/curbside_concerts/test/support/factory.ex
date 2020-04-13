defmodule CurbsideConcerts.Factory do
  alias CurbsideConcerts.Repo

  alias CurbsideConcerts.Accounts.User
  alias CurbsideConcerts.Musicians.Genre
  alias CurbsideConcerts.Musicians.Musician
  alias CurbsideConcerts.Musicians.Session
  alias CurbsideConcerts.Requests.Request

  def attrs(:musician) do
    %{
      name: Faker.Name.name(),
      bio: Faker.Lorem.Shakespeare.as_you_like_it(),
      # TBD: generate fake list of songs
      playlist: [],
      gigs_id: Faker.Internet.user_name()
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
      contact_preference: "call_nominee",
      nominee_phone: Faker.Phone.EnUs.phone(),
      nominee_address: Faker.Address.street_address(),
      song: Faker.String.base64(),
      special_message: Faker.StarWars.quote(),
      requester_name: Faker.Name.name(),
      requester_phone: Faker.Phone.EnUs.phone(),
      requester_email: Faker.Internet.email()
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

  def build(:request) do
    struct(Request, attrs(:request))
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

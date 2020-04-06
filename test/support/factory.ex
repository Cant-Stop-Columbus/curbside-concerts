defmodule HelloWeb.Factory do
  alias Hello.Repo

  alias Hello.Musicians.Musician
  alias Hello.Musicians.Session

  def attrs(:musician) do
    %{
      name: Faker.Name.name(),
      bio: Faker.Lorem.Shakespeare.as_you_like_it(),
      # TBD: generate fake list of songs
      playlist: [],
      gigs_id: "tmp"
    }
  end

  def attrs(:session) do
    %{
      name: "",
      description: ""
      # TBD: how to add a relationship??
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

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert!(build(factory_name, attributes))
  end
end

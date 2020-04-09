# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CurbsideConcerts.Repo.insert!(%CurbsideConcerts.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

musician1 =
  CurbsideConcerts.Repo.insert!(%CurbsideConcerts.Musicians.Musician{
    gigs_id: "remington",
    name: "Remington Ortiz",
    playlist: [
      "Hallelujah",
      "Ico Ico",
      "American Pie",
      "Blackbird",
      "The Times They Are A Changin’",
      "Heart of Gold"
    ]
  })

musician2 =
  CurbsideConcerts.Repo.insert!(%CurbsideConcerts.Musicians.Musician{
    gigs_id: "misscornell",
    name: "Miss Cornell Emmerich PhD",
    playlist: [
      "Song for No One",
      "Came in Through the Bathroom Window",
      "Hey Jude",
      "Gentle on My Mind",
      "Early Morning Rain"
    ]
  })

CurbsideConcerts.Repo.insert!(%CurbsideConcerts.Musicians.Session{
  name: "Songs with Remington",
  description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  musician: musician1
})

CurbsideConcerts.Repo.insert!(%CurbsideConcerts.Musicians.Session{
  name: "Songs with Miss Cornell",
  description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  musician: musician2
})

CurbsideConcerts.Repo.insert!(%CurbsideConcerts.Musicians.Genre{
  name: "Country"
})

CurbsideConcerts.Repo.insert!(%CurbsideConcerts.Musicians.Genre{
  name: "Pop"
})

CurbsideConcerts.Repo.insert!(%CurbsideConcerts.Musicians.Genre{
  name: "Rock"
})

CurbsideConcerts.Repo.insert!(%CurbsideConcerts.Musicians.Genre{
  name: "Marching Band"
})

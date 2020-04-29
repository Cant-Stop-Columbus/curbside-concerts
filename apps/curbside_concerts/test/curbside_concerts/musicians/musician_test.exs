defmodule CurbsideConcerts.Requests.RequestTest do
  use CurbsideConcerts.DataCase

  import CurbsideConcerts.Factory

  alias CurbsideConcerts.Musicians.Musician

  setup do
    musician = build(:musician)
    {:ok, musician: musician}
  end

  describe "changeset/2" do
    test "valid changeset for creation" do
      changeset = Musician.changeset(%Musician{}, attrs(:musician))
      assert changeset.errors == []
    end

    test "valid changeset for updates", %{musician: musician} do 
      attrs = %{"first_name" => "someone"}
      changeset = Musician.changeset(musician, attrs)
      
      assert changeset.errors == []
      assert changeset.changes.first_name == "someone"
    end

    test "invalid changeset", %{musician: musician} do
      attrs = %{"first_name" => nil}
      changeset = Musician.changeset(musician, attrs)
      
      assert changeset.errors == [
        {:first_name, {"Please provide an answer", [validation: :required]}}
      ]
      assert changeset.changes == %{}
    end
  end
end

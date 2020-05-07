defmodule CurbsideConcerts.MusiciansTest do
  use CurbsideConcerts.DataCase, async: true

  import CurbsideConcerts.Factory

  alias CurbsideConcerts.Musicians
  alias CurbsideConcerts.Musicians.Session

  describe "all_active_sessions" do
    test "returns all active sessions" do
      %Session{id: id1} = insert!(:session)
      %Session{id: id2} = insert!(:session)
      %Session{id: id3} = insert!(:session)
      %Session{id: id4} = insert!(:session, %{archived: true})
      %Session{id: id5} = insert!(:session, %{archived: true})

      session_ids =
        Musicians.all_active_sessions()
        |> Enum.map(fn s -> s.id end)

      assert Enum.member?(session_ids, id1)
      assert Enum.member?(session_ids, id2)
      assert Enum.member?(session_ids, id3)
      refute Enum.member?(session_ids, id4)
      refute Enum.member?(session_ids, id5)
    end
  end

  describe "all_archived_sessions" do
    test "returns all archived sessions" do
      %Session{id: id1} = insert!(:session)
      %Session{id: id2} = insert!(:session)
      %Session{id: id3} = insert!(:session)
      %Session{id: id4} = insert!(:session, %{archived: true})
      %Session{id: id5} = insert!(:session, %{archived: true})

      session_ids =
        Musicians.all_archived_sessions()
        |> Enum.map(fn s -> s.id end)

      refute Enum.member?(session_ids, id1)
      refute Enum.member?(session_ids, id2)
      refute Enum.member?(session_ids, id3)
      assert Enum.member?(session_ids, id4)
      assert Enum.member?(session_ids, id5)
    end
  end

  describe "create_musician/2" do
    test "duplicate url_pathname" do 
      insert!(:musician, %{ url_pathname: "url"})

      attrs = attrs(:musician, %{ url_pathname: "url"})
      {:error, changeset} = Musicians.create_musician(attrs)
      assert changeset.errors == [                                                                  
        url_pathname: {"has already been taken",                                 
         [constraint: :unique, constraint_name: "musicians_url_pathname_index"]} 
      ]                                                                       
    end
  end
end

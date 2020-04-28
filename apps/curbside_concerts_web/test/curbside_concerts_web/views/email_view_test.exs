defmodule CurbsideConcertsWeb.EmailViewTest do
  use ExUnit.Case

  alias CurbsideConcertsWeb.EmailView

  describe "preference_display_text/1" do
    test "should return call_nominee display text" do
      assert "Call Nomniee" == EmailView.preference_display_text("call_nominee")
    end

    test "should return text_requester display text" do
      assert "Text me" == EmailView.preference_display_text("text_requester")
    end

    test "should return call_requester display text" do
      assert "Call me" == EmailView.preference_display_text("call_requester")
    end
  end
end

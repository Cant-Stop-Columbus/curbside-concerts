defmodule CurbsideConcertsWeb.MusicianView do
  use CurbsideConcertsWeb, :view

  alias CurbsideConcerts.Musicians.Musician

  def required_star do
    ~E|<span class="required">*</span>|
  end

  def musician_input(form, field, placeholder \\ "") do
    class = class(form, field)

    ~E"""
    <%= text_input(form, field, class: class, placeholder: placeholder) %>
    """
  end

  def musician_input(form, field, placeholder, type: :url) do
    class = class(form, field)

    ~E"""
    <%= url_input(form, field, class: class, placeholder: placeholder) %>
    """
  end

  def musician_inline_input(form, field, placeholder \\ "") do
    class = "inline-input " <> class(form, field)

    ~E"""
    <%= text_input(form, field, class: class, placeholder: placeholder) %>
    """
  end

  def musician_image(alt_text, base64_img) do
    ~E"""
    <img class="musician-img" alt=<%= alt_text %> src="data:image/png;base64, <%= base64_img %>"/>
    """
  end

  def musician_image_link(alt_text, src) do
    ~E"""
    <%= img_tag(src, class: "musician-img", alt: alt_text) %>
    """
  end

  def musician_textarea(form, field, placeholder \\ "") do
    class = class(form, field)

    ~E"""
    <%= textarea(form, field, class: class, placeholder: placeholder) %>
    """
  end

  defp class(form, field) do
    if form.errors[field], do: "not-valid", else: ""
  end

end

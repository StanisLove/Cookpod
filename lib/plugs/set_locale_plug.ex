defmodule CookpodWeb.Plugs.SetLocale do
  @moduledoc """
  Specifying the desired locale is via the URL.
  """

  @supported_locales Gettext.known_locales(CookpodWeb.Gettext)

  def init(_options), do: nil

  def call(%Plug.Conn{params: %{"locale" => locale}} = conn, _options)
  when locale in @supported_locales do
    CookpodWeb.Gettext |> Gettext.put_locale(locale)
    conn
  end

  def call(conn, _options), do: conn
end

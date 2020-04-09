defmodule CookpodWeb.Plugs.SetLocale do
  @moduledoc """
  Specifying the desired locale is via the URL.
  """

  import Plug.Conn

  @supported_locales Gettext.known_locales(CookpodWeb.Gettext)
  @locale_max_age 365 * 24 * 60 * 60

  def init(_options), do: nil

  def call(conn, _options) do
    case fetch_locale_from(conn) do
      nil ->
        conn

      locale ->
        CookpodWeb.Gettext |> Gettext.put_locale(locale)
        conn |> put_resp_cookie("locale", locale, max_age: @locale_max_age)
    end
  end

  defp fetch_locale_from(conn) do
    (conn.params["locale"] || conn.cookies["locale"]) |> check_locale
  end

  defp check_locale(locale) when locale in @supported_locales, do: locale
  defp check_locale(_), do: nil
end

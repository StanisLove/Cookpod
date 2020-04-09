defmodule CookpodWeb.LayoutView do
  use CookpodWeb, :view

  def new_locale(conn, locale, lang_title) do
    "<a href=\"#{Routes.page_path(conn, :index, locale: locale)}\">#{lang_title}</a>" |> raw
  end
end

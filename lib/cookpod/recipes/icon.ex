defmodule Cookpod.Recipes.Icon do
  @moduledoc "Recipe's Icon"

  alias ExAws.S3

  def upload(nil), do: nil

  def upload(data) do
    # TODO: name file as md5 from content
    object = "recipes/#{data.filename}"
    body = data.path |> File.read!()

    :cookpod
    |> S3.put_object(object, body, content_type: data.content_type)
    |> ExAws.request!()

    object
  end
end

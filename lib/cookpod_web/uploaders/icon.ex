defmodule Cookpod.Icon do
  @moduledoc "Uploader for icons"

  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :medium, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    @extension_whitelist |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:original, _), do: :skip

  def transform(:thumb, _) do
    {
      :convert,
      [
        "-strip",
        "-thumbnail 100x100\^",
        "-gravity center",
        "-extent 100x100",
        "-format png",
        "-limit area 10MB",
        "-limit disk 50MB"
      ]
      |> Enum.join(" "),
      :png
    }
  end

  def transform(:medium, _) do
    {:convert, "-strip -resize 650x -limit area 10MB -limit disk 50MB"}
  end

  # Override the persisted filenames:
  # def filename(version, _) do
  #   version
  # end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    module_name =
      scope.__struct__
      |> Module.split()
      |> List.last()
      |> String.downcase()
      |> Inflex.pluralize()

    "#{module_name}/#{scope.id}"
    # config_dir = Application.get_env(:waffle, :storage_dir)
    # storage_dir_path(config_dir, module_name, scope.id)
  end

  # defp storage_dir_path(nil, module_name, id), do: "#{module_name}/#{id}"

  # defp storage_dir_path(prefix, module_name, id), do: "#{prefix}/#{module_name}/#{id}"

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, _scope), do: "/images/no_image.png"

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end

  def local_path({file, scope}, size) do
    Path.join([storage_dir_prefix, url({file, scope}, size, signed: true)])
  end
end

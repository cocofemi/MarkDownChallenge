defmodule MarkdownEditorWeb.DownloadController do
  use MarkdownEditorWeb, :controller

  def serve_pdf(conn, %{"filename" => filename}) do
    path = Path.join("/tmp", filename)

    if File.exists?(path) do
      conn
      |> put_resp_content_type("application/pdf")
      |> put_resp_header("content-disposition", ~s[attachment; filename="#{filename}"])
      |> send_file(200, path)
    else
      send_resp(conn, 404, "File not found")
    end
  end
end

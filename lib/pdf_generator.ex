defmodule MarkdownEditor.PDFGenerator do
  @moduledoc """
  Generates a PDF from HTML using the HTML2PDF Rocket API.
  """

  def generate_pdf(html) do
    api_key =
      System.get_env("HTML2PDFROCKET_API_KEY") ||
        raise "Missing HTML2PDFROCKET_API_KEY environment variable"

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    body =
      URI.encode_query(%{
        apiKey: api_key,
        value: html,
        marginTop: 10,
        marginBottom: 10,
        marginLeft: 10,
        marginRight: 10,
        usePrint: true
      })

    case Finch.build(:post, "https://api.html2pdfrocket.com/pdf", headers, body)
         |> Finch.request(MarkdownEditor.Finch) do
      {:ok, %Finch.Response{status: 200, body: pdf}} ->
        {:ok, pdf}

      {:ok, %Finch.Response{status: status, body: body}} ->
        {:error, "HTML2PDF Rocket failed with status #{status}: #{body}"}

      {:error, reason} ->
        {:error, reason}
    end
  end
end

defmodule MarkdownEditorWeb.MarkdownLive do
  use MarkdownEditorWeb, :live_view
  alias MarkdownEditorWeb.Router.Helpers, as: Routes


  def mount(_params, _session, socket) do
    {:ok, assign(socket, markdown: "", html: "")}
  end


  def handle_event("update_markdown", %{"markdown" => md}, socket) do
  html = Earmark.as_html!(md)
  {:noreply, assign(socket, markdown: md, html: html)}
end


def handle_event("export_pdf", _params, socket) do
  html = socket.assigns.html

  filename = "markdown_export_#{DateTime.utc_now() |> DateTime.to_unix()}.pdf"
  temp_filepath = Path.join(System.tmp_dir!(), filename)
  export_path = Path.join("priv/static/exports", filename)

  File.mkdir_p!("priv/static/exports")
  :ok = ChromicPDF.print_to_pdf({:html, html}, output: temp_filepath)
  File.rename!(temp_filepath, export_path)

  # Push event to trigger download
  {:noreply,
   socket
   |> put_flash(:info, "Download starting...")
   |> push_event("export-pdf", %{url: "/exports/#{filename}"})}
end




def handle_event("copy_html", _params, socket) do
  {:noreply,
   socket
   |> put_flash(:info, "Copied to clipboard!")
   |> push_event("copy-html", %{html: socket.assigns.html})}
end



  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-2 gap-4 h-screen p-4">
      <div>
        <h2 class="text-xl font-bold mb-2">Markdown Input</h2>
        <form phx-change="update_markdown">
      <textarea
        name="markdown"
        class="w-full h-80 p-2 border rounded"
        placeholder="Type markdown here..."
      ><%= @markdown %></textarea>
    </form>
      </div>
      <div>
        <h2 class="text-xl font-bold mb-2">Rendered Output</h2>
        <div id="rendered-output" class="prose max-w-none border p-4 rounded h-80 overflow-auto" phx-hook="RenderHook">
          <%= raw(@html) %>
        </div>
        <div class="flex gap-2 mt-2">
          <button phx-click="export_pdf" class="bg-blue-500 text-white px-4 py-2 rounded">Export PDF</button>
          <button phx-click="copy_html" class="bg-green-500 text-white px-4 py-2 rounded">Copy</button>
        </div>
      </div>
    </div>
    """
  end
end

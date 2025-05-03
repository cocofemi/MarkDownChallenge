import Config

if config_env() == :prod do
  IO.puts(">>> Runtime loaded. Setting up endpoint...")

  database_url = System.fetch_env!("DATABASE_URL")
  secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :markdown_editor, MarkdownEditor.Repo,
    url: database_url,
    ssl: true,
    ssl_opts: [verify: :verify_none],
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :markdown_editor, MarkdownEditorWeb.Endpoint,
    url: [host: "markdownchallenge.onrender.com", port: 443],
    http: [port: port],
    check_origin: [
      "https://markdownchallenge.onrender.com",
      ~r/^https?:\/\/(www\.)?markdownchallenge\.onrender\.com$/
    ],
    secret_key_base: secret_key_base,
    server: true
end

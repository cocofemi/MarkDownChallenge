import Config

if config_env() == :prod do
  IO.puts(">>> Runtime loaded. Setting up endpoint...")

  database_url =
    System.fetch_env!("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "markdownchallenge.onrender.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :markdown_editor, MarkdownEditor.Repo,
    url: database_url,
    ssl: true,
    ssl_opts: [verify: :verify_none],
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :markdown_editor, MarkdownEditorWeb.Endpoint,
    url: [host: host, port: 443],
    check_origin: [~r/.*/], # temporarily allow all origins
    http: [port: port],
    secret_key_base: secret_key_base,
    server: true

  config :markdown_editor, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")
end

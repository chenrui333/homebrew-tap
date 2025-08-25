class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cb9ed31378e8b68864978975376d3bbb33f438d7747a114d00a2478dcae89dc0"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4594c6754ef1142ffa341825c94cb083ce5a15649ea05ab63eb9f901eecc0a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ad5647fe3bce8bd339cd7d2edc44f7061cfb8d705edb8641ac62f70b8ef234"
    sha256 cellar: :any_skip_relocation, ventura:       "f8b8801f5c992088601e3e71d50387f3b7dde110b14a56760368207f392f1c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35b6773f7c44a9a5807a503894b47335c033e9c3cb4db48384d8b0b9f7c1dadd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pg-schema-diff"

    generate_completions_from_executable(bin/"pg-schema-diff", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"schema.sql").write <<~SQL
      CREATE TABLE public.foobar (
        id serial PRIMARY KEY,
        message text,
        created_at timestamptz
      );
      CREATE INDEX message_idx ON public.foobar (message, created_at);
    SQL

    pg_port = free_port
    dsn = "postgres://postgres:postgres@127.0.0.1:#{pg_port}/postgres?sslmode=disable"

    output = shell_output("#{bin}/pg-schema-diff plan --from-dsn '#{dsn}' --to-dir #{testpath} 2>&1", 1)
    assert_match "Error: creating temp db factory", output
  end
end

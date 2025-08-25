class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cb9ed31378e8b68864978975376d3bbb33f438d7747a114d00a2478dcae89dc0"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e87fac3cffd6f9888bd1f83793b4666669211e1bfdb5c137a72cd59a9943f86b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2614c0ce2ae1b89703305261f62de92ad4c413d60ac720a2d04e9f6b8d04c00"
    sha256 cellar: :any_skip_relocation, ventura:       "1049765a3394da569e95f444948aa6d391c3273453f40d7388ab5f77bc547212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b32f2cc0faaaf1d568e61d8812a98fc975306f36cf19a98545f18067cfa250d"
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

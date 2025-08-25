class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "a763d45c8945f199e290cc1683da8f36181309f128053bbe802620619bf5f11e"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cb4d93aa46edd61eb3fb6a7de7fa15058ab68ba0064471c0b8620b22309eac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83d7a230f829150f005baa595497756d1072f294005021f7d2baae7136c61838"
    sha256 cellar: :any_skip_relocation, ventura:       "aa70088641ff3cb8e11af4d21c47c895bbe59a052ac3e5563ef705d8b5b901b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84dc2937f24f38bb4c3e4fb78b9eaff4df22d4cf2d6ed21df064d0eb382f4a4b"
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

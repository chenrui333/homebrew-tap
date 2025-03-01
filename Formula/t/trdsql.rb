class Trdsql < Formula
  desc "CLI tool that can execute SQL queries on CSV, LTSV, JSON, YAML and TBLN"
  homepage "https://github.com/noborus/trdsql"
  url "https://github.com/noborus/trdsql/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e3b8bef57330648d3f4b279bd4c652eaeba19aa4fae3fe05cfa596a2b3f4bc51"
  license "MIT"
  head "https://github.com/noborus/trdsql.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/noborus/trdsql.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/trdsql"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trdsql --version")

    (testpath/"test.csv").write <<~CSV
      name,age
      Alice,30
      Bob,25
    CSV

    output = shell_output("#{bin}/trdsql -ih 'SELECT name FROM test.csv where age > 25'")
    assert_equal "Alice", output.chomp
  end
end

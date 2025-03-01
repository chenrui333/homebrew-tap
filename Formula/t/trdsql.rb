class Trdsql < Formula
  desc "CLI tool that can execute SQL queries on CSV, LTSV, JSON, YAML and TBLN"
  homepage "https://github.com/noborus/trdsql"
  url "https://github.com/noborus/trdsql/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e3b8bef57330648d3f4b279bd4c652eaeba19aa4fae3fe05cfa596a2b3f4bc51"
  license "MIT"
  head "https://github.com/noborus/trdsql.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a01fffc25e9e94010bfff489abb72a911eb3a4edb28010e12174f6c1e13d1d35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5733be591b84e14fc953162c99ab034b48742bb5827119e1479e3a934a15178c"
    sha256 cellar: :any_skip_relocation, ventura:       "67062e0174af21e1d22b5dce4a0254f2f98a9e32756ee9d3f3fe4ce0f7b6cee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1827a50783039e5789f8fe1cef8c10169a764b74a4218bfbf910974d4bc884"
  end

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

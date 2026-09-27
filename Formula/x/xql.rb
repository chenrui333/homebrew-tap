class Xql < Formula
  desc "Query CSV files and SharePoint Lists with SQL"
  homepage "https://github.com/excelano/xql"
  url "https://github.com/excelano/xql/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "4a214d063425cdc090ce38f44cd4956d4863edc067f42a39ead49057242fd1c1"
  license "MIT"
  head "https://github.com/excelano/xql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c2f4876c723af1347c66307151777945fa29267abff8f416150ac33a69d20b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c2f4876c723af1347c66307151777945fa29267abff8f416150ac33a69d20b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b783be6523508e68e4658ec1d92dab9b77028890ca2883bf3cddcf2f62749706"
    sha256 cellar: :any,                 x86_64_linux:  "aa96a8533812fba8c79cc3e131d3bf1061fda8a212c88376681950f80a41f417"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/xql"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xql --version")
    (testpath/"input.csv").write("name\nalice\n")
    output = shell_output("#{bin}/xql csv #{testpath}/input.csv --exec 'SELECT name' --mode=csv")
    assert_equal %w[name alice], output.lines.map(&:strip)
  end
end

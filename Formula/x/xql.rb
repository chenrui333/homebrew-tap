class Xql < Formula
  desc "Query CSV files and SharePoint Lists with SQL"
  homepage "https://github.com/excelano/xql"
  url "https://github.com/excelano/xql/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "c9cebb929eaafddd6f15bf005f99cc6c0400af7663679ceacfe3781b382955e4"
  license "MIT"
  head "https://github.com/excelano/xql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c15f1f34d8335477a9fff6e4880187c78c057cfda87a043eafb2551310a005de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c15f1f34d8335477a9fff6e4880187c78c057cfda87a043eafb2551310a005de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba541e2fb9b2389b66d80633596f18853cae9e806d89ea131c0907e07f7fe581"
    sha256 cellar: :any,                 x86_64_linux:  "7f7a4dcde77c2aacd7568d4e91bf6d81c13c6986e22f500b7e618284dacf396c"
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

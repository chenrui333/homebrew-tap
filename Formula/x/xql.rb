class Xql < Formula
  desc "Query CSV files and SharePoint Lists with SQL"
  homepage "https://github.com/excelano/xql"
  url "https://github.com/excelano/xql/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "4a214d063425cdc090ce38f44cd4956d4863edc067f42a39ead49057242fd1c1"
  license "MIT"
  head "https://github.com/excelano/xql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7bf73478d9eece672475d6f6a57df92c5d761eb70b611c5ee80a74302acd2ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7bf73478d9eece672475d6f6a57df92c5d761eb70b611c5ee80a74302acd2ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7bf73478d9eece672475d6f6a57df92c5d761eb70b611c5ee80a74302acd2ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1508b92103c68df2fcafef27c1a07c246d2f4c5d80a4369cdf82fa9a22c97451"
    sha256 cellar: :any,                 x86_64_linux:  "3d79fe771955243fa0e8fe0fa189804a2817efa7ce502dd5640435141b1fc165"
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

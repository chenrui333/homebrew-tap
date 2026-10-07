class Xql < Formula
  desc "Query CSV files and SharePoint Lists with SQL"
  homepage "https://github.com/excelano/xql"
  url "https://github.com/excelano/xql/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "9f9d80e53ab0d775894459ce82247ad0c36555c61ea66b5514c13dfcbcda79ea"
  license "MIT"
  head "https://github.com/excelano/xql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3bf528ac8b424289efba9ea54bd40d9cd0170b7cdf18b7a80fce06e9240f353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3bf528ac8b424289efba9ea54bd40d9cd0170b7cdf18b7a80fce06e9240f353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4167f4bb4666e34bcb7a25a8c12790d2e543bffa3081931130abdfc535650663"
    sha256 cellar: :any,                 x86_64_linux:  "11beb25a2744b3df4e4ab043074814a644f5cedfa6a69140cd3c25b14ffb95f2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

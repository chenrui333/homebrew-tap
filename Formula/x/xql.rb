class Xql < Formula
  desc "Query CSV files and SharePoint Lists with SQL"
  homepage "https://github.com/excelano/xql"
  url "https://github.com/excelano/xql/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "9f9d80e53ab0d775894459ce82247ad0c36555c61ea66b5514c13dfcbcda79ea"
  license "MIT"
  head "https://github.com/excelano/xql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3407a296c02d1712ae1c870de18f7e0dca978077794843c1ef984a72122ea560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3407a296c02d1712ae1c870de18f7e0dca978077794843c1ef984a72122ea560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fea80ace01eb8b31546a23aa8dc83ee4b81f6d9869999ca79e7a127de7912c02"
    sha256 cellar: :any,                 x86_64_linux:  "1948bf09c281148313186b85ff3bfe7d80979ecd5a4100d44c96469608d02d43"
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

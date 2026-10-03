class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "0ab97d244e992a9ba53b082a6575b0d6b000f53ff8327ed7e16437b8f08d2501"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "721f982fddb36023e5f435b302aea58d3ba09ef4b0dc31750078347b3ea54176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721f982fddb36023e5f435b302aea58d3ba09ef4b0dc31750078347b3ea54176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "828be16115b7fcb9c080468e6540b6f3cf14ff9ac21fd4b95b7813f4ecf8986a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78a2386d206c9e5cbc9ddaf00b12c7e3f2f86288d433f984c2c2fbaa7186f5bb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/chroncal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chroncal version")

    ENV["CHRONCAL_DB"] = testpath/"chroncal.db"
    assert_equal "[]\n", shell_output("#{bin}/chroncal todo list --output json")
  end
end

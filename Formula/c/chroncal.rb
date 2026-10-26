class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "627b4542f999df76395abb2e332da2b8523da01563b86dbf452cc63a3602d785"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6945c91937b2ff1968a51b51add134251650310a32e8015513d477373a239562"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6945c91937b2ff1968a51b51add134251650310a32e8015513d477373a239562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1206efc33ff61fe1df915ccaf791d72c4911388720f38cb5668b7304285dac5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a481ca4442b0c37fbfe1336f988a2cc72ad3f1a28e82d2dcf25b6535e5077cfb"
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

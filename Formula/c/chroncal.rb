class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "00bb926a0a40a6e4964965f97abfa9892fe5c45405ae415831ff6e2cd8e451e8"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcf1855327fd4a5300ef76136a9b2f35799635e02760ab6ed9e7de78eb583cfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcf1855327fd4a5300ef76136a9b2f35799635e02760ab6ed9e7de78eb583cfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd46b721b10f35892857f57651fe2f02589f8005fe0fbeb6decc79d8415c4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bf065f0cdce5eb721dd303e1c966baf9524b27c77e028f2952121e9cb57cac4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/chroncal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chroncal version")

    ENV["CHRONCAL_DB"] = testpath/"chroncal.db"
    assert_equal "[]\n", shell_output("#{bin}/chroncal todo list --output json")
  end
end

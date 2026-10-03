class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "9c3445c66775fb8d54ddfb59c106b0c26265870b243bbe2a5cd3a5c8d2e464a3"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa24bd1e70c295722aaf6f2a285eaa71303592f6fa16cc5ae2a584668b5758d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa24bd1e70c295722aaf6f2a285eaa71303592f6fa16cc5ae2a584668b5758d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "273fba7dc4829b55bfb3b79e00c3e244164d4cc1cdf696063b53d0a81ac85861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c3abd5b17f291119f81eeca6a2d8d73b5023cb519a139702576ecec49190d2d"
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

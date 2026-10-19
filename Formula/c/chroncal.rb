class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "b09e03677e78339c0677e3bd1da12c08bf34a486083489afbd60c554c6b56f13"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52864d3a503ef1d3afc1e4c2897e66be16aa57a8ff233b3859864ce8e16903f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52864d3a503ef1d3afc1e4c2897e66be16aa57a8ff233b3859864ce8e16903f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60bea12a46801b0706e3bde1cdda9354aac7b4c6e1286291ea233fff06333aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ca483089993a9b1771e509e8ccd83d6b1248be2a6fe44d4d2c74d7772616ff"
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

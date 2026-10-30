class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "c0ddc148e1840eb4a75b322eb52f92a216b64d204aa53d6f93b222a1ed9adb36"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a75393869dcf8587af6a6b582c7eb4fa1dc11bfd0103a008fd422b03dea1feca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a75393869dcf8587af6a6b582c7eb4fa1dc11bfd0103a008fd422b03dea1feca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb830d596490f9cb7c63c644ac0b2df24e9af4928147a8c32e7980bd718d3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4193e3157ec4a8bac6086301a5d5866223eb3f26660ba6ba868de61e5807b4e3"
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

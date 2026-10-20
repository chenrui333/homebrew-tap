class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "b09e03677e78339c0677e3bd1da12c08bf34a486083489afbd60c554c6b56f13"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aae27e2f5fd0b868eecc9c02069c44e3a252b0c9952618605c79ddfd664b29ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aae27e2f5fd0b868eecc9c02069c44e3a252b0c9952618605c79ddfd664b29ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f69b255b0883cf98236bc1b6739e3a546f023a7d7fa31b5b6ea4e2f98f20b294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "858ee870b1ee0b1af04c3024411cdf425c6ee885a361341a6f3fb7a6cc424a23"
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

class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.92.tar.gz"
  sha256 "cc8b6d336243f3f4d5fb66d44ae1431010bc34c58fd7c7e851a6e51b0d6b9ad6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5d3a7638817928321d70c298fe82b25ba421766b8f3fc8a8090388dc5d6cd42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf6a959e837860ceb066be2a4d4cdcd2327c9a3306a3bfbbe85d623f9f3eaf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe8affdf654f85ad2875b451c2911ef19487986257051731cb9c1fadcb3e71c8"
    sha256 cellar: :any,                 x86_64_linux:  "115f026adea89a55562c2016ee4a1610729d747f74bed6dc969bc1a941d289d5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end

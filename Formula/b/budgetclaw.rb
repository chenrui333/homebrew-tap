class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.130.tar.gz"
  sha256 "38381e014d1beb2beae167783864e042fd486b5f4ea1f55461fc8f2d1bf585cc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "dab48fff3605de242bc2ea23b1a24ef18ff19bdea0b972a05317598be3421fe1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5679b56bc94fa6d14b650a94a1a14e989045c0af83d1e5f24eaca620b9dbde9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e1dd868a20c152928e1c3e9d6fcee3f07cce2e4a9176cc6242390970ac58954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4390e036518193f5665f97f1333b53383a0518d1fb05b30b265461fd1075b28e"
    sha256 cellar: :any,                 x86_64_linux:  "0f676d20193f775f7e3e9548efc472babbf8011433dda262cfc3534bb7aec0ad"
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

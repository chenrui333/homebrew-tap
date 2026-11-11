class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.116.tar.gz"
  sha256 "822a7173d4f70d8a04c6fd4035c63008bf10abcdf9dc911f8c5cb1eb8de46ec5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1d7776c8ce6add77b77759990740489ee15898eba075f44ce699193eaa4057a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2740e27d63e1eb67aa6e6385da0d396908fc4761ed789e5a126f9e9d76a6b0b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1426afe12b3f90863b95722bcc9fc294ea8b85840d224cb0c48c3e8e5354cf82"
    sha256 cellar: :any,                 x86_64_linux:  "6ae7b13415532fa9a7cc6ac405aac6d2bf09f39a077e2d06af659a0eea5a519d"
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

class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.104.tar.gz"
  sha256 "44c4fee9c4ff75229bc6f61224cae3aaf760bbc7476824f58041a6c19a23e816"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "980c79c6f0511e17a1fbab490a1ed9c0a69647a13ca8ad47516b71c167e1965b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3340cf603d8723f53beeddcd25241454dc2c97961b526a1ced184b571b41ddc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "113d8029966326066c0f69e11e2d270a2e11828ef0b70eb912ef0228df3a7ee7"
    sha256 cellar: :any,                 x86_64_linux:  "d1a846677385a8d4dde4bba0e7cd695d24dfa44cbf2d2526c681a09df8225dc9"
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

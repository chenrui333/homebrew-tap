class Aic < Formula
  desc "Fetch the latest changelogs for popular AI coding assistants"
  homepage "https://github.com/arimxyer/aic"
  url "https://github.com/arimxyer/aic/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "1beae995886f56c54c0cfe08a800cdcf304df0dad6819312181415423a905ad1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4de2b7fe467f9f628df0adc687f34531b2b6dd6506fc2906af58d612e2db78f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4de2b7fe467f9f628df0adc687f34531b2b6dd6506fc2906af58d612e2db78f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4de2b7fe467f9f628df0adc687f34531b2b6dd6506fc2906af58d612e2db78f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e579dbc1506adb01e41f9fe57b93d175cafd642b4b0d83999d3221e5966b0e"
    sha256 cellar: :any,                 x86_64_linux:  "94e5069f5d6c6b06288c723869c3a331f0ccd971a1ce2cb33fac07708cc17e4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aic --version")
    # Avoid network-dependent changelog lookups in CI.
    output = shell_output("#{bin}/aic not-a-real-assistant 2>&1", 1)
    assert_match "unknown command", output
  end
end
